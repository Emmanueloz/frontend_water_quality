import 'package:flutter/widgets.dart';
import 'package:frontend_water_quality/domain/models/ai/chat_session.dart';
import 'package:frontend_water_quality/domain/models/ai/chat_message.dart';
import 'package:frontend_water_quality/domain/models/ai/session_metadata.dart';
import 'package:frontend_water_quality/domain/repositories/ai_chat_repo.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';

class AiChatProvider with ChangeNotifier {
  final AiChatRepository _aiChatRepo;
  AuthProvider? _authProvider;
  dynamic _connectivityProvider;

  AiChatProvider(this._aiChatRepo, this._authProvider,
      [this._connectivityProvider]);

  // State variables
  ChatSession? _currentSession;
  bool _isLoading = false;
  bool _isInitializing = false;
  bool _isSendingMessage = false;
  String? _errorMessage;
  String? _currentAnalysisId;
  bool _isRetrying = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  // Getters
  ChatSession? get currentSession => _currentSession;
  bool get isLoading => _isLoading;
  bool get isInitializing => _isInitializing;
  bool get isSendingMessage => _isSendingMessage;
  String? get errorMessage => _errorMessage;
  String? get currentAnalysisId => _currentAnalysisId;
  List<ChatMessage> get messages => _currentSession?.messages ?? [];
  bool get hasSession => _currentSession != null;
  bool get isRetrying => _isRetrying;
  bool get isOffline => _connectivityProvider?.isOffline ?? false;

  /// Sets the auth provider for token management
  void setAuthProvider(AuthProvider? provider) {
    _handleAuthStateChange(provider);
    _authProvider = provider;
  }

  /// Sets the connectivity provider for network state management
  void setConnectivityProvider(dynamic provider) {
    _connectivityProvider = provider;
  }

  /// Initializes a chat session for the given analysis ID
  /// Creates a new session if one doesn't exist
  Future<bool> initializeSession(String analysisId) async {
    if (!await _ensureAuthenticated()) {
      return false;
    }

    if (isOffline) {
      _setError(
          "No internet connection. Please check your network and try again.");
      return false;
    }

    _isInitializing = true;
    _errorMessage = null;
    _currentAnalysisId = analysisId;
    notifyListeners();

    return await _initializeSessionWithRetry(analysisId);
  }

  /// Initializes session with retry logic
  Future<bool> _initializeSessionWithRetry(String analysisId) async {
    int retryCount = 0;

    while (retryCount <= _maxRetries) {
      try {
        // Check network connectivity before attempting
        if (isOffline) {
          _setError(
              "No internet connection. Please check your network and try again.");
          _isInitializing = false;
          notifyListeners();
          return false;
        }

        // First try to get existing session
        final sessionResult =
            await _aiChatRepo.getSession(analysisId, _authProvider!.token!);

        if (sessionResult.isSuccess && sessionResult.value != null) {
          _currentSession = sessionResult.value;
          _isInitializing = false;
          _isRetrying = false;
          notifyListeners();
          return true;
        }

        // If no existing session, create a new one
        final createResult =
            await _aiChatRepo.createSession(analysisId, _authProvider!.token!);

        if (createResult.isSuccess && createResult.value != null) {
          // Convert SessionResponse to ChatSession for initial state
          _currentSession = ChatSession(
            sessionId: createResult.value!.sessionId,
            context: createResult.value!.context,
            createdAt: DateTime.parse(createResult.value!.createdAt),
            updatedAt: null,
            messages: [],
            metadata: SessionMetadata(
              analysisId: analysisId,
              userId: _authProvider!.user?.uid ?? '',
              workspaceId: '', // Will be populated when we get full session
              meterId: '',
              analysisType: '',
            ),
          );

          _isInitializing = false;
          _isRetrying = false;
          notifyListeners();
          return true;
        } else {
          // Check if this is a retryable error
          if (_isRetryableError(createResult.message ?? "")) {
            retryCount++;
            if (retryCount <= _maxRetries) {
              _isRetrying = true;
              notifyListeners();

              // Wait with exponential backoff
              await Future.delayed(Duration(seconds: retryCount * 2));
              continue;
            }
          }

          _setError(createResult.message ?? "Failed to create session");
          _isInitializing = false;
          _isRetrying = false;
          notifyListeners();
          return false;
        }
      } catch (e) {
        retryCount++;
        if (retryCount <= _maxRetries) {
          _isRetrying = true;
          notifyListeners();

          // Wait with exponential backoff
          await Future.delayed(Duration(seconds: retryCount * 2));
          continue;
        }

        _setError("Network error: ${e.toString()}");
        _isInitializing = false;
        _isRetrying = false;
        notifyListeners();
        return false;
      }
    }

    return false;
  }

  /// Sends a message to the current chat session
  /// Automatically creates a session if one doesn't exist
  Future<bool> sendMessage(String message) async {
    if (!await _ensureAuthenticated()) {
      return false;
    }

    if (_currentAnalysisId == null) {
      _setError("No analysis selected for chat");
      return false;
    }

    // Validate and sanitize message input
    final validationResult = _validateAndSanitizeMessage(message);
    if (!validationResult.isValid) {
      _setError(validationResult.errorMessage!);
      return false;
    }

    final sanitizedMessage = validationResult.sanitizedMessage!;

    _isSendingMessage = true;
    _errorMessage = null;

    // Add user message to UI immediately for better UX
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'user',
      content: sanitizedMessage,
      timestamp: DateTime.now(),
    );

    if (_currentSession != null) {
      _currentSession = _currentSession!.copyWith(
        messages: [..._currentSession!.messages, userMessage],
      );
    }

    notifyListeners();

    return await _sendMessageWithRetry(sanitizedMessage, userMessage);
  }

  /// Sends message with retry logic for network failures
  Future<bool> _sendMessageWithRetry(
      String message, ChatMessage userMessage) async {
    _retryCount = 0;

    while (_retryCount <= _maxRetries) {
      try {
        // Check network connectivity before attempting
        if (isOffline) {
          _setError(
              "No internet connection. Please check your network and try again.");
          _isSendingMessage = false;
          _removeUserMessageOnFailure(userMessage);
          notifyListeners();
          return false;
        }

        final result = await _aiChatRepo.sendMessage(
          _currentAnalysisId!,
          message,
          _authProvider!.token!,
        );

        if (result.isSuccess && result.value != null) {
          // Success - reset retry count and add AI response
          _retryCount = 0;
          _isRetrying = false;

          final aiMessage = ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            role: 'assistant',
            content: result.value!.response,
            timestamp: DateTime.now(),
          );

          if (_currentSession != null) {
            _currentSession = _currentSession!.copyWith(
              messages: [..._currentSession!.messages, aiMessage],
              updatedAt: DateTime.now(),
            );
          } else {
            // If no session exists, create one with the messages
            _currentSession = ChatSession(
              sessionId: result.value!.sessionId,
              context: '',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              messages: [userMessage, aiMessage],
              metadata: SessionMetadata(
                analysisId: _currentAnalysisId!,
                userId: _authProvider!.user?.uid ?? '',
                workspaceId: '',
                meterId: '',
                analysisType: '',
              ),
            );
          }

          _isSendingMessage = false;
          notifyListeners();
          return true;
        } else {
          // Check if this is a retryable error
          if (_isRetryableError(result.message ?? "")) {
            _retryCount++;
            if (_retryCount <= _maxRetries) {
              _isRetrying = true;
              notifyListeners();

              // Wait with exponential backoff
              await Future.delayed(Duration(seconds: _retryCount * 2));
              continue;
            }
          }

          // Non-retryable error or max retries reached
          _removeUserMessageOnFailure(userMessage);
          _setError(result.message ?? "Failed to send message");
          _isSendingMessage = false;
          _isRetrying = false;
          notifyListeners();
          return false;
        }
      } catch (e) {
        _retryCount++;
        if (_retryCount <= _maxRetries) {
          _isRetrying = true;
          notifyListeners();

          // Wait with exponential backoff
          await Future.delayed(Duration(seconds: _retryCount * 2));
          continue;
        }

        // Max retries reached
        _removeUserMessageOnFailure(userMessage);
        _setError("Network error: ${e.toString()}");
        _isSendingMessage = false;
        _isRetrying = false;
        notifyListeners();
        return false;
      }
    }

    return false;
  }

  /// Removes user message from UI when sending fails
  void _removeUserMessageOnFailure(ChatMessage userMessage) {
    if (_currentSession != null) {
      final messages = _currentSession!.messages.toList();
      if (messages.isNotEmpty && messages.last.id == userMessage.id) {
        messages.removeLast();
        _currentSession = _currentSession!.copyWith(messages: messages);
      }
    }
  }

  /// Determines if an error is retryable
  bool _isRetryableError(String errorMessage) {
    final lowerError = errorMessage.toLowerCase();

    // Don't retry authentication or authorization errors
    final nonRetryableErrors = [
      'authentication failed',
      'access denied',
      'unauthorized',
      'forbidden',
      'invalid token',
      'token expired',
      '401',
      '403',
    ];

    if (nonRetryableErrors.any((error) => lowerError.contains(error))) {
      // If it's an authentication error, clear the session
      if (lowerError.contains('unauthorized') ||
          lowerError.contains('401') ||
          lowerError.contains('invalid token') ||
          lowerError.contains('token expired')) {
        clearSession();
      }
      return false;
    }

    // Retry network-related errors
    final retryableErrors = [
      'connection timeout',
      'connection error',
      'network error',
      'timeout',
      'failed to connect',
      'no internet',
      'connection refused',
      '500',
      '502',
      '503',
      '504',
    ];

    return retryableErrors.any((error) => lowerError.contains(error));
  }

  /// Retries the last failed operation
  Future<bool> retryLastOperation() async {
    if (isOffline) {
      _setError(
          "No internet connection. Please check your network and try again.");
      return false;
    }

    // For now, we'll implement retry for session initialization
    if (_currentAnalysisId != null && !hasSession) {
      return await initializeSession(_currentAnalysisId!);
    }

    return false;
  }

  /// Loads the complete session history from the server
  Future<bool> loadSessionHistory() async {
    if (!await _ensureAuthenticated()) {
      return false;
    }

    if (_currentAnalysisId == null) {
      _setError("No analysis selected for chat");
      return false;
    }

    if (isOffline) {
      _setError(
          "No internet connection. Please check your network and try again.");
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    return await _loadSessionHistoryWithRetry();
  }

  /// Loads session history with retry logic
  Future<bool> _loadSessionHistoryWithRetry() async {
    int retryCount = 0;

    while (retryCount <= _maxRetries) {
      try {
        // Check network connectivity before attempting
        if (isOffline) {
          _setError(
              "No internet connection. Please check your network and try again.");
          _isLoading = false;
          notifyListeners();
          return false;
        }

        final result = await _aiChatRepo.getSession(
            _currentAnalysisId!, _authProvider!.token!);

        if (result.isSuccess && result.value != null) {
          _currentSession = result.value;
          _isLoading = false;
          _isRetrying = false;
          notifyListeners();
          return true;
        } else {
          // Check if this is a retryable error
          if (_isRetryableError(result.message ?? "")) {
            retryCount++;
            if (retryCount <= _maxRetries) {
              _isRetrying = true;
              notifyListeners();

              // Wait with exponential backoff
              await Future.delayed(Duration(seconds: retryCount * 2));
              continue;
            }
          }

          _setError(result.message ?? "Failed to load session history");
          _isLoading = false;
          _isRetrying = false;
          notifyListeners();
          return false;
        }
      } catch (e) {
        retryCount++;
        if (retryCount <= _maxRetries) {
          _isRetrying = true;
          notifyListeners();

          // Wait with exponential backoff
          await Future.delayed(Duration(seconds: retryCount * 2));
          continue;
        }

        _setError("Network error: ${e.toString()}");
        _isLoading = false;
        _isRetrying = false;
        notifyListeners();
        return false;
      }
    }

    return false;
  }

  /// Clears the current chat session and resets state
  void clearSession() {
    _currentSession = null;
    _currentAnalysisId = null;
    _errorMessage = null;
    _isLoading = false;
    _isInitializing = false;
    _isSendingMessage = false;
    _isRetrying = false;
    _retryCount = 0;
    notifyListeners();
  }

  /// Clears any error messages
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Clears the current session and resets state
  void clearCurrentSession() {
    _currentSession = null;
    _currentAnalysisId = null;
    _errorMessage = null;
    _isLoading = false;
    _isInitializing = false;
    _isSendingMessage = false;
    _isRetrying = false;
    _retryCount = 0;
    notifyListeners();
  }

  /// Clears the current session and resets state, then initializes a new session
  /// This method is designed to be called during widget updates to avoid setState during build
  Future<void> reinitializeSession(String? analysisId) async {
    // Clear current state without notifying yet
    _currentSession = null;
    _currentAnalysisId = null;
    _errorMessage = null;
    _isLoading = false;
    _isInitializing = false;
    _isSendingMessage = false;
    _isRetrying = false;
    _retryCount = 0;

    // Schedule the initialization for the next frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (analysisId != null && analysisId.isNotEmpty) {
        await initializeSession(analysisId);
      } else {
        // Just notify listeners to update UI with cleared state
        notifyListeners();
      }
    });
  }

  /// Sets an error message and notifies listeners
  void _setError(String message) {
    _errorMessage = message;
  }

  /// Validates and sanitizes chat message input
  _MessageValidationResult _validateAndSanitizeMessage(String message) {
    // Basic null/empty check
    if (message.isEmpty) {
      return _MessageValidationResult(
        isValid: false,
        errorMessage: "Message cannot be empty",
      );
    }

    // Trim whitespace
    String sanitized = message.trim();

    // Check if message is empty after trimming
    if (sanitized.isEmpty) {
      return _MessageValidationResult(
        isValid: false,
        errorMessage: "Message cannot be empty",
      );
    }

    // Check message length limits
    if (sanitized.length > 4000) {
      return _MessageValidationResult(
        isValid: false,
        errorMessage:
            "Message cannot exceed 4000 characters (current: ${sanitized.length})",
      );
    }

    // Check minimum length
    if (sanitized.length < 1) {
      return _MessageValidationResult(
        isValid: false,
        errorMessage: "Message is too short",
      );
    }

    // Sanitize potentially harmful content
    sanitized = _sanitizeInput(sanitized);

    // Final validation after sanitization
    if (sanitized.trim().isEmpty) {
      return _MessageValidationResult(
        isValid: false,
        errorMessage: "Message contains only invalid characters",
      );
    }

    return _MessageValidationResult(
      isValid: true,
      sanitizedMessage: sanitized,
    );
  }

  /// Sanitizes user input for security
  String _sanitizeInput(String input) {
    // Remove or escape potentially harmful characters
    String sanitized = input;

    // Remove null bytes and control characters (except newlines and tabs)
    sanitized =
        sanitized.replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]'), '');

    // Limit consecutive whitespace
    sanitized = sanitized.replaceAll(RegExp(r'\s{10,}'), ' ');

    // Remove excessive newlines
    sanitized = sanitized.replaceAll(RegExp(r'\n{5,}'), '\n\n');

    // Trim final result
    return sanitized.trim();
  }

  /// Checks authentication before making API calls
  Future<bool> _ensureAuthenticated() async {
    if (_authProvider == null || !_authProvider!.isAuthenticated) {
      _setError("User not authenticated");
      return false;
    }

    if (_authProvider!.token == null || _authProvider!.token!.isEmpty) {
      _setError("Authentication token is missing");
      return false;
    }

    return true;
  }

  /// Handles authentication state changes
  void _handleAuthStateChange(AuthProvider? newAuthProvider) {
    final wasAuthenticated = _authProvider?.isAuthenticated ?? false;
    final isNowAuthenticated = newAuthProvider?.isAuthenticated ?? false;
    final oldToken = _authProvider?.token;
    final newToken = newAuthProvider?.token;

    // If user logged out or token changed, clear session
    if (wasAuthenticated && (!isNowAuthenticated || oldToken != newToken)) {
      clearSession();
    }

    // If user just logged in, clear any authentication errors
    if (!wasAuthenticated && isNowAuthenticated) {
      if (_errorMessage != null &&
          (_errorMessage!.toLowerCase().contains('authentication') ||
              _errorMessage!.toLowerCase().contains('unauthorized') ||
              _errorMessage!.toLowerCase().contains('token'))) {
        clearError();
      }
    }
  }

  /// Cleans up provider state (called when auth changes)
  void clean() {
    clearSession();
  }
}

/// Helper class for message validation results
class _MessageValidationResult {
  final bool isValid;
  final String? errorMessage;
  final String? sanitizedMessage;

  _MessageValidationResult({
    required this.isValid,
    this.errorMessage,
    this.sanitizedMessage,
  });
}
