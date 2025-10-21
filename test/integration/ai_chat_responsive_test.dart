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

// Mock provider for testing
class MockAiChatProvider extends AiChatProvider {
  bool _isInitializing = false;
  bool _isSendingMessage = false;
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
  bool get isLoading => false;

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
  group('AI Chat Responsive Design and Accessibility Tests', () {
    late MockAiChatProvider mockProvider;

    setUp(() {
      mockProvider = MockAiChatProvider();
    });

    Widget createTestWidget({
      required Size screenSize,
      ScreenSize? screenSizeEnum,
      String? analysisId,
      bool isInBottomSheet = false,
    }) {
      return MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: screenSize),
          child: Scaffold(
            body: SizedBox(
              width: screenSize.width,
              height: screenSize.height,
              child: ChangeNotifierProvider<AiChatProvider>.value(
                value: mockProvider,
                child: ChatAiPage(
                  analysisId: analysisId ?? 'test-analysis',
                  screenSize: screenSizeEnum ?? ScreenSize.largeDesktop,
                  isInBottomSheet: isInBottomSheet,
                ),
              ),
            ),
          ),
        ),
      );
    }

    group('Responsive Design Tests', () {
      testWidgets('should adapt to mobile screen size (360x640)',
          (WidgetTester tester) async {
        const mobileSize = Size(360, 640);
        mockProvider.setHasSession(true);
        mockProvider.setMessages([
          ChatMessage(
            id: '1',
            role: 'user',
            content: 'Test message on mobile',
            timestamp: DateTime.now(),
          ),
          ChatMessage(
            id: '2',
            role: 'assistant',
            content: 'AI response on mobile device',
            timestamp: DateTime.now(),
          ),
        ]);

        await tester.pumpWidget(createTestWidget(
          screenSize: mobileSize,
          screenSizeEnum: ScreenSize.mobile,
        ));
        await tester.pumpAndSettle();

        // Verify the widget renders without overflow
        expect(tester.takeException(), isNull);

        // Verify messages are displayed
        expect(find.text('Test message on mobile'), findsOneWidget);
        expect(find.text('AI response on mobile device'), findsOneWidget);

        // Verify input field is present and accessible
        expect(find.byType(TextField), findsOneWidget);
        expect(find.byIcon(Icons.send), findsOneWidget);

        // Verify the layout fits within screen bounds
        final chatWidget = find.byType(ChatAiPage);
        expect(chatWidget, findsOneWidget);

        final RenderBox renderBox = tester.renderObject(chatWidget);
        expect(renderBox.size.width, lessThanOrEqualTo(mobileSize.width));
        expect(renderBox.size.height, lessThanOrEqualTo(mobileSize.height));
      });

      testWidgets('should adapt to tablet screen size (768x1024)',
          (WidgetTester tester) async {
        const tabletSize = Size(768, 1024);
        mockProvider.setHasSession(true);
        mockProvider.setMessages([
          ChatMessage(
            id: '1',
            role: 'user',
            content:
                'Test message on tablet with longer text that should wrap properly',
            timestamp: DateTime.now(),
          ),
          ChatMessage(
            id: '2',
            role: 'assistant',
            content:
                'AI response on tablet device with more space for content display',
            timestamp: DateTime.now(),
          ),
        ]);

        await tester.pumpWidget(createTestWidget(
          screenSize: tabletSize,
          screenSizeEnum: ScreenSize.tablet,
        ));
        await tester.pumpAndSettle();

        // Verify the widget renders without overflow
        expect(tester.takeException(), isNull);

        // Verify messages are displayed
        expect(
            find.text(
                'Test message on tablet with longer text that should wrap properly'),
            findsOneWidget);
        expect(
            find.text(
                'AI response on tablet device with more space for content display'),
            findsOneWidget);

        // Verify input components
        expect(find.byType(TextField), findsOneWidget);
        expect(find.byIcon(Icons.send), findsOneWidget);

        // Verify the layout utilizes available space appropriately
        final chatWidget = find.byType(ChatAiPage);
        expect(chatWidget, findsOneWidget);

        final RenderBox renderBox = tester.renderObject(chatWidget);
        expect(renderBox.size.width, lessThanOrEqualTo(tabletSize.width));
        expect(renderBox.size.height, lessThanOrEqualTo(tabletSize.height));
      });

      testWidgets('should adapt to desktop screen size (1920x1080)',
          (WidgetTester tester) async {
        const desktopSize = Size(1920, 1080);
        mockProvider.setHasSession(true);
        mockProvider.setMessages([
          ChatMessage(
            id: '1',
            role: 'user',
            content:
                'Test message on desktop with full keyboard input capabilities',
            timestamp: DateTime.now(),
          ),
          ChatMessage(
            id: '2',
            role: 'assistant',
            content:
                'AI response on desktop with plenty of screen real estate for detailed responses and analysis',
            timestamp: DateTime.now(),
          ),
        ]);

        await tester.pumpWidget(createTestWidget(
          screenSize: desktopSize,
          screenSizeEnum: ScreenSize.largeDesktop,
        ));
        await tester.pumpAndSettle();

        // Verify the widget renders without overflow
        expect(tester.takeException(), isNull);

        // Verify messages are displayed
        expect(
            find.text(
                'Test message on desktop with full keyboard input capabilities'),
            findsOneWidget);
        expect(
            find.text(
                'AI response on desktop with plenty of screen real estate for detailed responses and analysis'),
            findsOneWidget);

        // Verify input components
        expect(find.byType(TextField), findsOneWidget);
        expect(find.byIcon(Icons.send), findsOneWidget);

        // Verify the layout uses desktop space effectively
        final chatWidget = find.byType(ChatAiPage);
        expect(chatWidget, findsOneWidget);

        final RenderBox renderBox = tester.renderObject(chatWidget);
        expect(renderBox.size.width, lessThanOrEqualTo(desktopSize.width));
        expect(renderBox.size.height, lessThanOrEqualTo(desktopSize.height));
      });

      testWidgets('should handle very long messages without overflow',
          (WidgetTester tester) async {
        const mobileSize = Size(360, 640);
        const longMessage =
            'This is a very long message that should wrap properly across multiple lines without causing any overflow issues in the chat interface. It contains detailed information about water quality analysis including pH levels, temperature readings, dissolved oxygen content, and various other parameters that are important for comprehensive water quality assessment.';

        mockProvider.setHasSession(true);
        mockProvider.setMessages([
          ChatMessage(
            id: '1',
            role: 'user',
            content: longMessage,
            timestamp: DateTime.now(),
          ),
          ChatMessage(
            id: '2',
            role: 'assistant',
            content: longMessage,
            timestamp: DateTime.now(),
          ),
        ]);

        await tester.pumpWidget(createTestWidget(
          screenSize: mobileSize,
          screenSizeEnum: ScreenSize.mobile,
        ));
        await tester.pumpAndSettle();

        // Verify no overflow errors
        expect(tester.takeException(), isNull);

        // Verify messages are displayed (even if truncated)
        expect(find.textContaining('This is a very long message'),
            findsAtLeastNWidgets(1));
      });

      testWidgets('should work in bottom sheet mode',
          (WidgetTester tester) async {
        const mobileSize = Size(360, 640);
        mockProvider.setHasSession(true);

        await tester.pumpWidget(createTestWidget(
          screenSize: mobileSize,
          screenSizeEnum: ScreenSize.mobile,
          isInBottomSheet: true,
        ));
        await tester.pumpAndSettle();

        // Verify the widget renders in bottom sheet mode
        expect(tester.takeException(), isNull);
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
        expect(find.byType(SafeArea), findsOneWidget);
      });

      testWidgets('should handle screen orientation changes',
          (WidgetTester tester) async {
        // Portrait mode
        const portraitSize = Size(360, 640);
        mockProvider.setHasSession(true);
        mockProvider.setMessages([
          ChatMessage(
            id: '1',
            role: 'user',
            content: 'Portrait mode message',
            timestamp: DateTime.now(),
          ),
        ]);

        await tester.pumpWidget(createTestWidget(
          screenSize: portraitSize,
          screenSizeEnum: ScreenSize.mobile,
        ));
        await tester.pumpAndSettle();

        expect(find.text('Portrait mode message'), findsOneWidget);
        expect(tester.takeException(), isNull);

        // Landscape mode
        const landscapeSize = Size(640, 360);
        await tester.pumpWidget(createTestWidget(
          screenSize: landscapeSize,
          screenSizeEnum: ScreenSize.mobile,
        ));
        await tester.pumpAndSettle();

        expect(find.text('Portrait mode message'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper semantic labels for screen readers',
          (WidgetTester tester) async {
        mockProvider.setHasSession(true);
        mockProvider.setMessages([
          ChatMessage(
            id: '1',
            role: 'user',
            content: 'User message for accessibility test',
            timestamp: DateTime.now(),
          ),
          ChatMessage(
            id: '2',
            role: 'assistant',
            content: 'AI response for accessibility test',
            timestamp: DateTime.now(),
          ),
        ]);

        await tester.pumpWidget(createTestWidget(
          screenSize: const Size(800, 600),
        ));
        await tester.pumpAndSettle();

        // Verify text input has proper semantics
        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);

        final textFieldWidget = tester.widget<TextField>(textField);
        expect(textFieldWidget.decoration?.hintText, isNotNull);

        // Verify send button is accessible
        final sendButton = find.byIcon(Icons.send);
        expect(sendButton, findsOneWidget);

        // Verify messages are accessible to screen readers
        expect(
            find.text('User message for accessibility test'), findsOneWidget);
        expect(find.text('AI response for accessibility test'), findsOneWidget);
      });

      testWidgets('should support keyboard navigation',
          (WidgetTester tester) async {
        mockProvider.setHasSession(true);

        await tester.pumpWidget(createTestWidget(
          screenSize: const Size(800, 600),
        ));
        await tester.pumpAndSettle();

        // Test tab navigation to text field
        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);

        // Focus the text field
        await tester.tap(textField);
        await tester.pumpAndSettle();

        // Verify text input works
        await tester.enterText(textField, 'Keyboard input test');
        expect(find.text('Keyboard input test'), findsOneWidget);

        // Test Enter key to send message (if enabled)
        final textFieldWidget = tester.widget<TextField>(textField);
        expect(textFieldWidget.textInputAction, equals(TextInputAction.send));
      });

      testWidgets('should handle high contrast themes',
          (WidgetTester tester) async {
        mockProvider.setHasSession(true);
        mockProvider.setMessages([
          ChatMessage(
            id: '1',
            role: 'user',
            content: 'High contrast test message',
            timestamp: DateTime.now(),
          ),
        ]);

        // Create high contrast theme
        final highContrastTheme = ThemeData(
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
            primary: Colors.white,
            onPrimary: Colors.black,
            surface: Colors.black,
            onSurface: Colors.white,
            error: Colors.red,
            onError: Colors.white,
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: highContrastTheme,
            home: Scaffold(
              body: SizedBox(
                width: 800,
                height: 600,
                child: ChangeNotifierProvider<AiChatProvider>.value(
                  value: mockProvider,
                  child: const ChatAiPage(
                    analysisId: 'test-analysis',
                    screenSize: ScreenSize.largeDesktop,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify the widget renders with high contrast theme
        expect(tester.takeException(), isNull);
        expect(find.text('High contrast test message'), findsOneWidget);
      });

      testWidgets('should support text scaling for accessibility',
          (WidgetTester tester) async {
        mockProvider.setHasSession(true);
        mockProvider.setMessages([
          ChatMessage(
            id: '1',
            role: 'user',
            content: 'Text scaling test',
            timestamp: DateTime.now(),
          ),
        ]);

        // Test with large text scale
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(800, 600),
                textScaler: TextScaler.linear(2.0), // 200% text scaling
              ),
              child: Scaffold(
                body: SizedBox(
                  width: 800,
                  height: 600,
                  child: ChangeNotifierProvider<AiChatProvider>.value(
                    value: mockProvider,
                    child: const ChatAiPage(
                      analysisId: 'test-analysis',
                      screenSize: ScreenSize.largeDesktop,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify the widget renders with scaled text without overflow
        expect(tester.takeException(), isNull);
        expect(find.text('Text scaling test'), findsOneWidget);
      });

      testWidgets('should provide proper error message accessibility',
          (WidgetTester tester) async {
        mockProvider.setErrorMessage('network connection failed');
        mockProvider.setHasSession(false);

        await tester.pumpWidget(createTestWidget(
          screenSize: const Size(800, 600),
        ));
        await tester.pumpAndSettle();

        // Verify error message is accessible
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        // Check for the translated network error message
        expect(find.text('Error de conexión. Verifica tu conexión a internet.'),
            findsOneWidget);

        // Verify retry button is accessible
        expect(find.text('Reintentar'), findsOneWidget);

        // Test retry button interaction
        await tester.tap(find.text('Reintentar'));
        await tester.pumpAndSettle();

        // Should not crash
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle loading states accessibly',
          (WidgetTester tester) async {
        mockProvider.setInitializing(true);

        await tester.pumpWidget(createTestWidget(
          screenSize: const Size(800, 600),
        ));
        await tester
            .pump(); // Use pump instead of pumpAndSettle to avoid animation timeout

        // Verify loading indicator is present and accessible
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Verify input is properly disabled during loading
        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);

        final textFieldWidget = tester.widget<TextField>(textField);
        expect(textFieldWidget.enabled, isFalse);

        // Verify send button is disabled
        final sendButton = find.byIcon(Icons.send);
        expect(sendButton, findsOneWidget);

        final iconButton = tester.widget<IconButton>(find.ancestor(
          of: sendButton,
          matching: find.byType(IconButton),
        ));
        expect(iconButton.onPressed, isNull);
      });

      testWidgets('should provide typing indicator accessibility',
          (WidgetTester tester) async {
        mockProvider.setHasSession(true);
        mockProvider.setSendingMessage(true);
        // Add at least one message so the ListView shows the typing indicator
        mockProvider.setMessages([
          ChatMessage(
            id: '1',
            role: 'user',
            content: 'Test message',
            timestamp: DateTime.now(),
          ),
        ]);

        await tester.pumpWidget(createTestWidget(
          screenSize: const Size(800, 600),
        ));
        await tester.pump();

        // Verify typing indicator is accessible
        expect(find.text('IA está escribiendo'), findsOneWidget);

        // Verify animated dots are present
        expect(find.byType(TweenAnimationBuilder<double>),
            findsAtLeastNWidgets(1));

        // Pump additional frames to clear any pending timers
        await tester.pump(const Duration(milliseconds: 200));
      });
    });

    group('Layout Integration Tests', () {
      testWidgets(
          'should maintain proper spacing and padding across screen sizes',
          (WidgetTester tester) async {
        final screenSizes = [
          const Size(360, 640), // Mobile
          const Size(768, 1024), // Tablet
          const Size(1920, 1080), // Desktop
        ];

        for (final screenSize in screenSizes) {
          mockProvider.setHasSession(true);
          mockProvider.setMessages([
            ChatMessage(
              id: '1',
              role: 'user',
              content: 'Test message',
              timestamp: DateTime.now(),
            ),
          ]);

          await tester.pumpWidget(createTestWidget(
            screenSize: screenSize,
          ));
          await tester.pumpAndSettle();

          // Verify no overflow errors
          expect(tester.takeException(), isNull);

          // Verify essential components are present
          expect(find.byType(TextField), findsOneWidget);
          expect(find.byIcon(Icons.send), findsOneWidget);
          expect(find.text('Test message'), findsOneWidget);
        }
      });

      testWidgets('should handle empty state consistently across screen sizes',
          (WidgetTester tester) async {
        final screenSizes = [
          const Size(360, 640), // Mobile
          const Size(768, 1024), // Tablet
          const Size(1920, 1080), // Desktop
        ];

        for (final screenSize in screenSizes) {
          mockProvider.setHasSession(false);
          mockProvider.setMessages([]);

          await tester.pumpWidget(createTestWidget(
            screenSize: screenSize,
          ));
          await tester.pumpAndSettle();

          // Verify empty state is displayed properly
          expect(find.byIcon(Icons.psychology_outlined), findsOneWidget);
          expect(find.text('Pregunta sobre los datos de calidad de agua'),
              findsOneWidget);

          // Verify no overflow
          expect(tester.takeException(), isNull);
        }
      });
    });
  });
}
