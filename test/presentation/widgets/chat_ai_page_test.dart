import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/chat_ai_page.dart';
import 'package:frontend_water_quality/presentation/providers/ai_chat_provider.dart';
import 'package:frontend_water_quality/domain/models/ai/chat_message.dart';
import 'package:frontend_water_quality/domain/models/ai/chat_session.dart';
import 'package:frontend_water_quality/domain/models/ai/session_metadata.dart';
import 'package:frontend_water_quality/domain/models/ai/chat_response.dart';
import 'package:frontend_water_quality/domain/models/ai/session_response.dart';
import 'package:frontend_water_quality/domain/repositories/ai_chat_repo.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';

// Simple mock provider for testing
class MockAiChatProvider extends AiChatProvider {
  bool _isInitializing = false;
  bool _isSendingMessage = false;
  final bool _isLoading = false;
  bool _hasSession = false;
  String? _errorMessage;
  List<ChatMessage> _messages = [];
  String? _currentAnalysisId;

  MockAiChatProvider() : super(MockAiChatRepository(), null);

  @override
  bool get isInitializing => _isInitializing;

  @override
  bool get isSendingMessage => _isSendingMessage;

  @override
  bool get isLoading => _isLoading;

  @override
  bool get hasSession => _hasSession;

  @override
  String? get errorMessage => _errorMessage;

  @override
  List<ChatMessage> get messages => _messages;

  @override
  String? get currentAnalysisId => _currentAnalysisId;

  void setInitializing(bool value) {
    _isInitializing = value;
    notifyListeners();
  }

  void setSendingMessage(bool value) {
    _isSendingMessage = value;
    notifyListeners();
  }

  void setHasSession(bool value) {
    _hasSession = value;
    notifyListeners();
  }

  void setErrorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  void setMessages(List<ChatMessage> value) {
    _messages = value;
    notifyListeners();
  }

  @override
  Future<bool> initializeSession(String analysisId) async {
    _currentAnalysisId = analysisId;
    return true;
  }

  @override
  Future<bool> sendMessage(String message) async {
    return true;
  }

  @override
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

// Mock repository
class MockAiChatRepository extends AiChatRepository {
  @override
  Future<Result<SessionResponse>> createSession(
      String analysisId, String token) async {
    return Result.success(SessionResponse(
      sessionId: analysisId,
      context: 'Mock context',
      createdAt: DateTime.now().toIso8601String(),
    ));
  }

  @override
  Future<Result<ChatResponse>> sendMessage(
      String analysisId, String message, String token) async {
    return Result.success(ChatResponse(
      response: 'Mock AI response',
      sessionId: analysisId,
    ));
  }

  @override
  Future<Result<ChatSession>> getSession(
      String analysisId, String token) async {
    return Result.success(ChatSession(
      sessionId: analysisId,
      context: 'Mock context',
      createdAt: DateTime.now(),
      messages: [],
      metadata: SessionMetadata(
        analysisId: analysisId,
        userId: 'test-user',
        workspaceId: 'test-workspace',
        meterId: 'test-meter',
        analysisType: 'test-type',
      ),
    ));
  }
}

void main() {
  group('ChatAiPage Widget Tests', () {
    late MockAiChatProvider mockProvider;

    setUp(() {
      mockProvider = MockAiChatProvider();
    });

    Widget createTestWidget({String? analysisId}) {
      return MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 600,
            child: ChangeNotifierProvider<AiChatProvider>.value(
              value: mockProvider,
              child: ChatAiPage(
                analysisId: analysisId,
                screenSize: ScreenSize.largeDesktop,
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('displays empty state when no messages',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(analysisId: 'test-analysis'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.psychology_outlined), findsOneWidget);
      expect(find.text('Pregunta sobre los datos de calidad de agua'),
          findsOneWidget);
    });

    testWidgets('displays loading indicator when initializing',
        (WidgetTester tester) async {
      mockProvider.setInitializing(true);

      await tester.pumpWidget(createTestWidget(analysisId: 'test-analysis'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays messages correctly', (WidgetTester tester) async {
      final messages = [
        ChatMessage(
          id: '1',
          role: 'user',
          content: 'Test user message',
          timestamp: DateTime.now(),
        ),
        ChatMessage(
          id: '2',
          role: 'assistant',
          content: 'Test AI response',
          timestamp: DateTime.now(),
        ),
      ];

      mockProvider.setMessages(messages);
      mockProvider.setHasSession(true);

      await tester.pumpWidget(createTestWidget(analysisId: null));
      await tester.pump();

      expect(find.text('Test user message'), findsOneWidget);
      expect(find.text('Test AI response'), findsOneWidget);
    });

    testWidgets('displays typing indicator when sending message',
        (WidgetTester tester) async {
      // Add at least one message so the ListView is rendered
      final messages = [
        ChatMessage(
          id: '1',
          role: 'user',
          content: 'Test message',
          timestamp: DateTime.now(),
        ),
      ];

      mockProvider.setMessages(messages);
      mockProvider.setSendingMessage(true);
      mockProvider.setHasSession(true);

      await tester.pumpWidget(createTestWidget(analysisId: null));
      await tester.pump();

      expect(find.text('IA está escribiendo'), findsOneWidget);
    });

    testWidgets('displays error message when error occurs without session',
        (WidgetTester tester) async {
      mockProvider.setErrorMessage('Test error message');
      mockProvider.setHasSession(false);

      await tester.pumpWidget(createTestWidget(analysisId: 'test-analysis'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Error inesperado. Por favor, intenta nuevamente.'),
          findsOneWidget);
      expect(find.text('Reintentar'), findsOneWidget);
    });

    testWidgets('displays error banner when error occurs with session',
        (WidgetTester tester) async {
      mockProvider.setErrorMessage('Test error message');
      mockProvider.setHasSession(true);

      await tester.pumpWidget(createTestWidget(analysisId: 'test-analysis'));
      await tester.pumpAndSettle();

      expect(find.text('Error inesperado. Por favor, intenta nuevamente.'),
          findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('can enter text and tap send button',
        (WidgetTester tester) async {
      mockProvider.setHasSession(true);

      await tester.pumpWidget(createTestWidget(analysisId: 'test-analysis'));
      await tester.pumpAndSettle();

      // Enter text in the input field
      await tester.enterText(find.byType(TextField), 'Test message');
      expect(find.text('Test message'), findsOneWidget);

      // Verify send button is present and can be tapped
      expect(find.byIcon(Icons.send), findsOneWidget);
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();
    });

    testWidgets('disables input when initializing',
        (WidgetTester tester) async {
      mockProvider.setInitializing(true);

      await tester.pumpWidget(createTestWidget(analysisId: null));
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, false);

      final sendButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(sendButton.onPressed, null);
    });

    testWidgets('disables input when sending message',
        (WidgetTester tester) async {
      // Add at least one message so the ListView is rendered
      final messages = [
        ChatMessage(
          id: '1',
          role: 'user',
          content: 'Test message',
          timestamp: DateTime.now(),
        ),
      ];

      mockProvider.setMessages(messages);
      mockProvider.setSendingMessage(true);
      mockProvider.setHasSession(true);

      await tester.pumpWidget(createTestWidget(analysisId: null));
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, false);

      // Should show loading indicator instead of send icon
      expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
    });

    testWidgets('shows close button in error banner',
        (WidgetTester tester) async {
      mockProvider.setErrorMessage('Test error');
      mockProvider.setHasSession(true);

      await tester.pumpWidget(createTestWidget(analysisId: 'test-analysis'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();
    });

    testWidgets('shows retry button when error occurs without session',
        (WidgetTester tester) async {
      mockProvider.setErrorMessage('Test error');
      mockProvider.setHasSession(false);

      await tester.pumpWidget(createTestWidget(analysisId: 'test-analysis'));
      await tester.pumpAndSettle();

      expect(find.text('Reintentar'), findsOneWidget);
      await tester.tap(find.text('Reintentar'));
      await tester.pump();
    });

    testWidgets('filters out system messages from display',
        (WidgetTester tester) async {
      final messages = [
        ChatMessage(
          id: '1',
          role: 'user',
          content: 'User message',
          timestamp: DateTime.now(),
        ),
        ChatMessage(
          id: '2',
          role: 'system',
          content: 'System message',
          timestamp: DateTime.now(),
        ),
        ChatMessage(
          id: '3',
          role: 'assistant',
          content: 'AI response',
          timestamp: DateTime.now(),
        ),
      ];

      mockProvider.setMessages(messages);
      mockProvider.setHasSession(true);

      await tester.pumpWidget(createTestWidget(analysisId: null));
      await tester.pump();

      expect(find.text('User message'), findsOneWidget);
      expect(find.text('System message'), findsNothing);
      expect(find.text('AI response'), findsOneWidget);
    });

    testWidgets('has send button for message input',
        (WidgetTester tester) async {
      mockProvider.setHasSession(true);

      await tester.pumpWidget(createTestWidget(analysisId: 'test-analysis'));
      await tester.pumpAndSettle();

      // Verify send button exists
      expect(find.byIcon(Icons.send), findsOneWidget);

      // Try to tap send button (should not crash)
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();
    });

    testWidgets('shows copy button for AI messages',
        (WidgetTester tester) async {
      final messages = [
        ChatMessage(
          id: '1',
          role: 'user',
          content: 'User message',
          timestamp: DateTime.now(),
        ),
        ChatMessage(
          id: '2',
          role: 'assistant',
          content: 'AI response with **markdown**',
          timestamp: DateTime.now(),
        ),
      ];

      mockProvider.setMessages(messages);
      mockProvider.setHasSession(true);

      await tester.pumpWidget(createTestWidget(analysisId: null));
      await tester.pump();

      // Verify copy button exists for AI message
      expect(find.text('Copiar'), findsOneWidget);
      expect(find.byIcon(Icons.copy), findsOneWidget);

      // Try to tap copy button (should not crash)
      await tester.tap(find.text('Copiar'));
      await tester.pump();
    });

    testWidgets('cleans AI response text from special tokens', (WidgetTester tester) async {
      final messages = [
        ChatMessage(
          id: '1',
          role: 'assistant',
          content: '<｜begin▁of▁sentence｜>AI response with special tokens<｜end▁of▁sentence｜>',
          timestamp: DateTime.now(),
        ),
      ];

      mockProvider.setMessages(messages);
      mockProvider.setHasSession(true);

      await tester.pumpWidget(createTestWidget(analysisId: null));
      await tester.pump();

      // Verify the cleaned text is displayed (without special tokens)
      expect(find.text('AI response with special tokens'), findsOneWidget);
      // Verify the special tokens are not displayed
      expect(find.textContaining('<｜begin▁of▁sentence｜>'), findsNothing);
      expect(find.textContaining('<｜end▁of▁sentence｜>'), findsNothing);
    });

    group('Error Message Translation', () {
      testWidgets('translates authentication errors',
          (WidgetTester tester) async {
        mockProvider.setErrorMessage('401 authentication failed');
        mockProvider.setHasSession(false);

        await tester.pumpWidget(createTestWidget(analysisId: 'test-analysis'));
        await tester.pumpAndSettle();

        expect(
            find.text('Sesión expirada. Por favor, inicia sesión nuevamente.'),
            findsOneWidget);
      });

      testWidgets('translates access denied errors',
          (WidgetTester tester) async {
        mockProvider.setErrorMessage('403 access denied');
        mockProvider.setHasSession(false);

        await tester.pumpWidget(createTestWidget(analysisId: 'test-analysis'));
        await tester.pumpAndSettle();

        expect(find.text('No tienes acceso a este análisis.'), findsOneWidget);
      });

      testWidgets('translates not found errors', (WidgetTester tester) async {
        mockProvider.setErrorMessage('404 not found');
        mockProvider.setHasSession(false);

        await tester.pumpWidget(createTestWidget(analysisId: 'test-analysis'));
        await tester.pumpAndSettle();

        expect(find.text('Análisis no encontrado o no disponible para chat.'),
            findsOneWidget);
      });

      testWidgets('translates analysis not ready errors',
          (WidgetTester tester) async {
        mockProvider.setErrorMessage('400 analysis not ready');
        mockProvider.setHasSession(false);

        await tester.pumpWidget(createTestWidget(analysisId: 'test-analysis'));
        await tester.pumpAndSettle();

        expect(
            find.text(
                'El análisis debe estar completado antes de usar el chat.'),
            findsOneWidget);
      });

      testWidgets('translates network errors', (WidgetTester tester) async {
        mockProvider.setErrorMessage('network connection failed');
        mockProvider.setHasSession(false);

        await tester.pumpWidget(createTestWidget(analysisId: 'test-analysis'));
        await tester.pumpAndSettle();

        expect(find.text('Error de conexión. Verifica tu conexión a internet.'),
            findsOneWidget);
      });
    });
  });
}
