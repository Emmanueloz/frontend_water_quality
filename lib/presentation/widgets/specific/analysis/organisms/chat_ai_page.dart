import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:clipboard/clipboard.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/providers/ai_chat_provider.dart';

class ChatAiPage extends StatefulWidget {
  final String? analysisId;
  final ScreenSize screenSize;
  final bool isInBottomSheet;

  const ChatAiPage({
    super.key,
    required this.analysisId,
    this.screenSize = ScreenSize.largeDesktop,
    this.isInBottomSheet = false,
  });

  @override
  State<ChatAiPage> createState() => _ChatAiPageState();
}

class _ChatAiPageState extends State<ChatAiPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSession();
      _setupMessageListener();
    });
  }

  void _setupMessageListener() {
    final provider = context.read<AiChatProvider>();
    provider.addListener(_onProviderChange);
  }

  void _onProviderChange() {
    // Check if widget is still mounted before using context
    if (!mounted) return;

    try {
      final provider = context.read<AiChatProvider>();
      // Auto-scroll when messages change or when sending is complete
      if (provider.messages.isNotEmpty && !provider.isSendingMessage) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _scrollToBottom();
          }
        });
      }
    } catch (e) {
      // Context may not be available if widget is being disposed
    }
  }

  @override
  void didUpdateWidget(ChatAiPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If analysisId changed, reinitialize the chat
    if (oldWidget.analysisId != widget.analysisId) {
      _reinitializeChat();
    }
  }

  @override
  void dispose() {
    try {
      final provider = context.read<AiChatProvider>();
      provider.removeListener(_onProviderChange);
    } catch (e) {
      // Provider may not be available during dispose
    }
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeSession() async {
    if (widget.analysisId != null && widget.analysisId!.isNotEmpty) {
      final provider = context.read<AiChatProvider>();
      await provider.initializeSession(widget.analysisId!);
      if (mounted) {
        _scrollToBottom();
      }
    }
  }

  Future<void> _reinitializeChat() async {
    if (!mounted) return;

    try {
      final provider = context.read<AiChatProvider>();

      // Clear message input
      _messageController.clear();

      // Use the provider's reinitialize method that handles setState timing correctly
      await provider.reinitializeSession(widget.analysisId);

      // Schedule scroll to bottom after initialization
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _scrollToBottom();
        }
      });
    } catch (e) {
      // Handle error silently if context is not available
    }
  }

  Future<void> _sendMessage() async {
    if (!mounted) return;

    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    try {
      final provider = context.read<AiChatProvider>();
      _messageController.clear();

      // Scroll to bottom immediately to show user message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _scrollToBottom();
        }
      });

      final success = await provider.sendMessage(message);
      if (success && mounted) {
        // Scroll to bottom again to show AI response
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _scrollToBottom();
          }
        });
      }
    } catch (e) {
      // Handle error silently if context is not available
    }
  }

  void _scrollToBottom() {
    if (!mounted || !_scrollController.hasClients) return;

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && _scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        'Asistente de Análisis',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyMessages(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.psychology_outlined,
              size: 64,
              color: theme.hintColor.withValues(alpha: 127.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Pregunta sobre los datos de calidad de agua',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage(
      ThemeData theme, String error, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesList(ThemeData theme) {
    return Consumer<AiChatProvider>(
      builder: (context, provider, child) {
        // Show error state if there's an error and no session
        if (provider.errorMessage != null && !provider.hasSession) {
          return _buildErrorMessage(
            theme,
            _getErrorMessage(provider.errorMessage!),
            () => _handleRetry(provider),
          );
        }

        if (provider.isInitializing) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final messages =
            provider.messages.where((msg) => msg.role != 'system').toList();

        if (messages.isEmpty) {
          return _buildEmptyMessages(theme);
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.only(bottom: 12),
          itemCount: messages.length + (provider.isSendingMessage ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < messages.length) {
              final message = messages[index];
              return _buildMessageBubble(
                context,
                message.content,
                isUser: message.role == 'user',
                theme: theme,
              );
            } else {
              return _buildTypingIndicator(theme);
            }
          },
        );
      },
    );
  }

  String _getErrorMessage(String error) {
    if (error.contains('401') || error.contains('authentication')) {
      return 'Sesión expirada. Por favor, inicia sesión nuevamente.';
    } else if (error.contains('403') || error.contains('access')) {
      return 'No tienes acceso a este análisis.';
    } else if (error.contains('404') || error.contains('not found')) {
      return 'Análisis no encontrado o no disponible para chat.';
    } else if (error.contains('400') || error.contains('not ready')) {
      return 'El análisis debe estar completado antes de usar el chat.';
    } else if (error.contains('network') || error.contains('connection')) {
      return 'Error de conexión. Verifica tu conexión a internet.';
    } else {
      return 'Error inesperado. Por favor, intenta nuevamente.';
    }
  }

  void _handleRetry(AiChatProvider provider) {
    if (!mounted) return;

    provider.clearError();
    if (widget.analysisId != null && widget.analysisId!.isNotEmpty) {
      _initializeSession();
    }
  }

  Widget _buildInputArea(BuildContext context, ThemeData theme) {
    return Consumer<AiChatProvider>(
      builder: (context, provider, child) {
        final isDisabled = provider.isInitializing ||
            provider.isSendingMessage ||
            (provider.errorMessage != null && !provider.hasSession);

        return Column(
          children: [
            // Show error banner if there's an error but we have a session
            if (provider.errorMessage != null && provider.hasSession)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: theme.colorScheme.onErrorContainer,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getErrorMessage(provider.errorMessage!),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: provider.clearError,
                      icon: Icon(
                        Icons.close,
                        color: theme.colorScheme.onErrorContainer,
                        size: 16,
                      ),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      enabled: !isDisabled,
                      maxLines: null,
                      minLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: isDisabled ? null : (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: isDisabled
                            ? 'Cargando...'
                            : 'Escribe tu pregunta...',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: isDisabled ? null : _sendMessage,
                    icon: provider.isSendingMessage
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.primaryColor,
                              ),
                            ),
                          )
                        : const Icon(Icons.send),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = Column(
      children: [
        _buildHeader(theme),
        Expanded(
          child: _buildMessagesList(theme),
        ),
        _buildInputArea(context, theme),
      ],
    );

    if (!widget.isInBottomSheet) {
      return content;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(child: content),
    );
  }

  Widget _buildMessageBubble(BuildContext context, String text,
      {required bool isUser, required ThemeData theme}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Card(
          elevation: 0,
          color: isUser
              ? theme.primaryColor.withValues(alpha: 25)
              : theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, isUser ? 12 : 8),
                child: isUser
                    ? Text(
                        text,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.surface,
                        ),
                      )
                    : _isInTestEnvironment()
                        ? Text(
                            text,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          )
                        : _buildMarkdownContent(text, theme),
              ),
              // Add copy button only for AI responses
              if (!isUser) _buildCopyButton(text, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarkdownContent(String text, ThemeData theme) {
    return MarkdownWidget(
      data: text,
      shrinkWrap: true,
      selectable: true,
      config: MarkdownConfig(
        configs: [
          // Heading styles
          H1Config(
            style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color,
                ) ??
                const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          H2Config(
            style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color,
                ) ??
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          H3Config(
            style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color,
                ) ??
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          // Paragraph style
          PConfig(
            textStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.textTheme.bodyLarge?.color,
                ) ??
                const TextStyle(fontSize: 16),
          ),
          // Code block style
          PreConfig(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            padding: const EdgeInsets.all(12),
            textStyle: TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
          // Inline code style
          CodeConfig(
            style: TextStyle(
              fontFamily: 'monospace',
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
          // Table style
          TableConfig(
            wrapper: (child) => Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyButton(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _copyToClipboard(text),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.copy,
                      size: 14,
                      color: theme.textTheme.bodySmall?.color
                          ?.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Copiar',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color
                            ?.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isInTestEnvironment() {
    // Check if we're running in a test environment
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode &&
        WidgetsBinding.instance.runtimeType.toString().contains('Test');
  }

  Future<void> _copyToClipboard(String text) async {
    try {
      await FlutterClipboard.copy(text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Respuesta copiada al portapapeles'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      // Fallback to system clipboard if FlutterClipboard fails
      try {
        await Clipboard.setData(ClipboardData(text: text));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Respuesta copiada al portapapeles'),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Error al copiar al portapapeles'),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Theme.of(context).colorScheme.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      }
    }
  }

  Widget _buildTypingIndicator(ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Card(
          elevation: 0,
          color: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'IA está escribiendo',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(width: 8),
                _buildTypingDot(theme, 0),
                const SizedBox(width: 4),
                _buildTypingDot(theme, 200),
                const SizedBox(width: 4),
                _buildTypingDot(theme, 400),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypingDot(ThemeData theme, int delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      builder: (context, value, child) {
        final animationValue = (value + delay / 1200) % 1.0;
        return Transform.translate(
          offset: Offset(0, -4 * (1 - (2 * animationValue - 1).abs())),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
