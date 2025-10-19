import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';

class ChatAiPage extends StatefulWidget {
  final String? averageId;
  final ScreenSize screenSize;
  final bool isInBottomSheet;

  const ChatAiPage({
    super.key,
    required this.averageId,
    this.screenSize = ScreenSize.largeDesktop,
    this.isInBottomSheet = false,
  });

  @override
  State<ChatAiPage> createState() => _ChatAiPageState();
}

class _ChatAiPageState extends State<ChatAiPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add({'text': message, 'isUser': true});
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response (replace with actual API call)
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'text':
                'Esta es una respuesta simulada del asistente de IA. Pronto podrás obtener información detallada sobre tus datos de calidad de agua.',
            'isUser': false,
          });
          _isLoading = false;
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
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

  Widget _buildMessagesList(ThemeData theme) {
    return _messages.isEmpty
        ? _buildEmptyMessages(theme)
        : ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 12),
            itemCount: _messages.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < _messages.length) {
                final message = _messages[index];
                return _buildMessageBubble(
                  context,
                  message['text'],
                  isUser: message['isUser'],
                  theme: theme,
                );
              } else {
                return _buildTypingIndicator(theme);
              }
            },
          );
  }

  Widget _buildInputArea(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              maxLines: null,
              minLines: 1,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Escribe tu pregunta...',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send),
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              text,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isUser
                    ? theme.colorScheme.surface
                    : theme.textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTypingDot(theme, 0),
            const SizedBox(width: 4),
            _buildTypingDot(theme, 200),
            const SizedBox(width: 4),
            _buildTypingDot(theme, 400),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingDot(ThemeData theme, int delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      builder: (context, value, child) {
        return Opacity(
          opacity: (value * 2).clamp(0.0, 1.0) * 0.7 + 0.3,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * -8),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: theme.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}
