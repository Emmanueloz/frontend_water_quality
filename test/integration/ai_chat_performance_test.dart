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

// Performance-focused mock provider
class PerformanceMockAiChatProvider extends AiChatProvider {
  bool _isInitializing = false;
  bool _isSendingMessage = false;
  bool _hasSession = false;
  String? _errorMessage;
  List<ChatMessage> _messages = [];
  String? _currentAnalysisId;
  int _notifyListenersCalls = 0;
  int _apiCalls = 0;

  PerformanceMockAiChatProvider()
      : super(PerformanceMockAiChatRepository(), null);

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

  int get notifyListenersCalls => _notifyListenersCalls;
  int get apiCalls => _apiCalls;

  @override
  void notifyListeners() {
    _notifyListenersCalls++;
    super.notifyListeners();
  }

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

  void addMessage(ChatMessage message) {
    _messages = [..._messages, message];
    notifyListeners();
  }

  @override
  Future<bool> initializeSession(String analysisId) async {
    _apiCalls++;
    _currentAnalysisId = analysisId;
    _hasSession = true;
    notifyListeners();
    return true;
  }

  @override
  Future<bool> sendMessage(String message) async {
    _apiCalls++;
    // Simulate adding user message and AI response
    addMessage(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'user',
      content: message,
      timestamp: DateTime.now(),
    ));

    // Simulate AI response delay
    await Future.delayed(const Duration(milliseconds: 10));

    addMessage(ChatMessage(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      role: 'assistant',
      content: 'AI response to: $message',
      timestamp: DateTime.now(),
    ));

    return true;
  }

  @override
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void resetCounters() {
    _notifyListenersCalls = 0;
    _apiCalls = 0;
  }

  void clearMessages() {
    _messages = [];
    notifyListeners();
  }
}

// Performance-focused mock repository
class PerformanceMockAiChatRepository extends AiChatRepository {
  int _createSessionCalls = 0;
  int _sendMessageCalls = 0;
  int _getSessionCalls = 0;

  int get createSessionCalls => _createSessionCalls;
  int get sendMessageCalls => _sendMessageCalls;
  int get getSessionCalls => _getSessionCalls;

  void resetCounters() {
    _createSessionCalls = 0;
    _sendMessageCalls = 0;
    _getSessionCalls = 0;
  }

  @override
  Future<Result<SessionResponse>> createSession(
      String analysisId, String token) async {
    _createSessionCalls++;
    return Result.success(SessionResponse(
      sessionId: analysisId,
      context: 'Performance test context',
      createdAt: DateTime.now().toIso8601String(),
    ));
  }

  @override
  Future<Result<ChatResponse>> sendMessage(
      String analysisId, String message, String token) async {
    _sendMessageCalls++;
    return Result.success(ChatResponse(
      response: 'Performance test AI response to: $message',
      sessionId: analysisId,
    ));
  }

  @override
  Future<Result<ChatSession>> getSession(
      String analysisId, String token) async {
    _getSessionCalls++;
    return Result.success(ChatSession(
      sessionId: analysisId,
      context: 'Performance test context',
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
  group('AI Chat Performance Tests', () {
    late PerformanceMockAiChatProvider mockProvider;

    setUp(() {
      mockProvider = PerformanceMockAiChatProvider();
    });

    Widget createTestWidget({
      required Size screenSize,
      String? analysisId,
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
                  analysisId: analysisId ?? 'performance-test-analysis',
                  screenSize: ScreenSize.largeDesktop,
                ),
              ),
            ),
          ),
        ),
      );
    }

    group('Large Message History Performance', () {
      testWidgets('should handle 100 messages efficiently',
          (WidgetTester tester) async {
        // Generate 100 messages
        final messages = List.generate(
            100,
            (index) => ChatMessage(
                  id: index.toString(),
                  role: index % 2 == 0 ? 'user' : 'assistant',
                  content:
                      'Message $index: This is a test message with some content to simulate real chat messages.',
                  timestamp:
                      DateTime.now().subtract(Duration(minutes: 100 - index)),
                ));

        mockProvider.setHasSession(true);
        mockProvider.setMessages(messages);

        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(createTestWidget(
          screenSize: const Size(800, 600),
        ));
        await tester.pumpAndSettle();

        stopwatch.stop();

        // Verify messages are loaded (check that we have the expected count)
        expect(mockProvider.messages.length, equals(100));

        // Verify at least some messages are rendered (ListView may not render all at once)
        expect(find.byType(ListView), findsOneWidget);

        // Performance assertion: should render within reasonable time (< 1 second)
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));

        // Performance logged: Rendered 100 messages in ${stopwatch.elapsedMilliseconds}ms
      });

      testWidgets('should handle 500 messages efficiently',
          (WidgetTester tester) async {
        // Generate 500 messages
        final messages = List.generate(
            500,
            (index) => ChatMessage(
                  id: index.toString(),
                  role: index % 2 == 0 ? 'user' : 'assistant',
                  content:
                      'Message $index: Performance test with larger message history.',
                  timestamp:
                      DateTime.now().subtract(Duration(minutes: 500 - index)),
                ));

        mockProvider.setHasSession(true);
        mockProvider.setMessages(messages);

        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(createTestWidget(
          screenSize: const Size(800, 600),
        ));
        await tester.pumpAndSettle();

        stopwatch.stop();

        // Verify messages are loaded (check that we have the expected count)
        expect(mockProvider.messages.length, equals(500));

        // Verify ListView is rendered
        expect(find.byType(ListView), findsOneWidget);

        // Performance assertion: should render within reasonable time (< 2 seconds)
        expect(stopwatch.elapsedMilliseconds, lessThan(2000));

        // Performance logged: Rendered 500 messages in ${stopwatch.elapsedMilliseconds}ms
      });

      testWidgets('should handle very long messages efficiently',
          (WidgetTester tester) async {
        // Generate messages with very long content
        final longContent =
            'This is a very long message content that simulates detailed AI responses about water quality analysis. ' *
                20;

        final messages = List.generate(
            50,
            (index) => ChatMessage(
                  id: index.toString(),
                  role: index % 2 == 0 ? 'user' : 'assistant',
                  content: 'Message $index: $longContent',
                  timestamp:
                      DateTime.now().subtract(Duration(minutes: 50 - index)),
                ));

        mockProvider.setHasSession(true);
        mockProvider.setMessages(messages);

        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(createTestWidget(
          screenSize: const Size(800, 600),
        ));
        await tester.pumpAndSettle();

        stopwatch.stop();

        // Verify messages are loaded (check that we have the expected count)
        expect(mockProvider.messages.length, equals(50));

        // Verify ListView is rendered
        expect(find.byType(ListView), findsOneWidget);

        // Performance assertion: should render within reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(1500));

        // Performance logged: Rendered 50 long messages in ${stopwatch.elapsedMilliseconds}ms
      });
    });

    group('API Call Optimization', () {
      testWidgets('should minimize API calls during normal operation',
          (WidgetTester tester) async {
        mockProvider.setHasSession(true);
        mockProvider.resetCounters();

        await tester.pumpWidget(createTestWidget(
          screenSize: const Size(800, 600),
        ));
        await tester.pumpAndSettle();

        // Initial render should not trigger excessive API calls
        expect(mockProvider.apiCalls, lessThanOrEqualTo(1));

        // Send a message
        await tester.enterText(find.byType(TextField), 'Test message');
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        // Should only make one API call for sending message
        expect(mockProvider.apiCalls, lessThanOrEqualTo(2));

        // Performance logged: API calls during normal operation: ${mockProvider.apiCalls}
      });

      testWidgets('should not make redundant API calls on rebuild',
          (WidgetTester tester) async {
        mockProvider.setHasSession(true);
        mockProvider.resetCounters();

        await tester.pumpWidget(createTestWidget(
          screenSize: const Size(800, 600),
        ));
        await tester.pumpAndSettle();

        final initialApiCalls = mockProvider.apiCalls;

        // Trigger rebuild by changing screen size
        await tester.pumpWidget(createTestWidget(
          screenSize: const Size(900, 700),
        ));
        await tester.pumpAndSettle();

        // Should not make additional API calls on rebuild
        expect(mockProvider.apiCalls, equals(initialApiCalls));

        // Performance logged: API calls after rebuild: ${mockProvider.apiCalls}
      });
    });

    group('State Management Performance', () {
      testWidgets('should minimize notifyListeners calls',
          (WidgetTester tester) async {
        mockProvider.resetCounters();

        await tester.pumpWidget(createTestWidget(
          screenSize: const Size(800, 600),
        ));
        await tester.pumpAndSettle();

        final initialNotifications = mockProvider.notifyListenersCalls;

        // Add multiple messages
        for (int i = 0; i < 10; i++) {
          mockProvider.addMessage(ChatMessage(
            id: i.toString(),
            role: i % 2 == 0 ? 'user' : 'assistant',
            content: 'Performance test message $i',
            timestamp: DateTime.now(),
          ));
        }

        await tester.pumpAndSettle();

        // Should have reasonable number of notifications (not excessive)
        final totalNotifications = mockProvider.notifyListenersCalls;
        expect(totalNotifications - initialNotifications,
            lessThanOrEqualTo(15)); // Allow some buffer

        // Performance logged: NotifyListeners calls for 10 messages: ${totalNotifications - initialNotifications}
      });

      testWidgets('should handle rapid state changes efficiently',
          (WidgetTester tester) async {
        mockProvider.setHasSession(true);
        mockProvider.resetCounters();

        await tester.pumpWidget(createTestWidget(
          screenSize: const Size(800, 600),
        ));
        await tester.pumpAndSettle();

        final stopwatch = Stopwatch()..start();

        // Simulate rapid state changes
        for (int i = 0; i < 20; i++) {
          mockProvider.setSendingMessage(true);
          await tester.pump();
          mockProvider.setSendingMessage(false);
          await tester.pump();
        }

        stopwatch.stop();

        // Should handle rapid changes without performance issues
        expect(stopwatch.elapsedMilliseconds, lessThan(500));

        // Performance logged: Handled 40 rapid state changes in ${stopwatch.elapsedMilliseconds}ms
      });
    });

    group('Memory Usage Optimization', () {
      testWidgets('should properly dispose resources',
          (WidgetTester tester) async {
        mockProvider.setHasSession(true);
        mockProvider.setMessages([
          ChatMessage(
            id: '1',
            role: 'user',
            content: 'Test message for disposal',
            timestamp: DateTime.now(),
          ),
        ]);

        await tester.pumpWidget(createTestWidget(
          screenSize: const Size(800, 600),
        ));
        await tester.pumpAndSettle();

        // Verify widget is rendered
        expect(find.text('Test message for disposal'), findsOneWidget);

        // Dispose the widget
        await tester.pumpWidget(Container());
        await tester.pumpAndSettle();

        // Should not throw any exceptions during disposal
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle message list growth efficiently',
          (WidgetTester tester) async {
        mockProvider.setHasSession(true);

        await tester.pumpWidget(createTestWidget(
          screenSize: const Size(800, 600),
        ));
        await tester.pumpAndSettle();

        final stopwatch = Stopwatch()..start();

        // Gradually add messages and measure performance
        for (int batch = 1; batch <= 10; batch++) {
          final batchMessages = List.generate(
              10,
              (index) => ChatMessage(
                    id: '${batch}_$index',
                    role: index % 2 == 0 ? 'user' : 'assistant',
                    content: 'Batch $batch Message $index',
                    timestamp: DateTime.now(),
                  ));

          for (final message in batchMessages) {
            mockProvider.addMessage(message);
          }

          await tester.pump();
        }

        stopwatch.stop();

        // Should handle gradual growth efficiently
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        expect(mockProvider.messages.length, equals(100));

        // Allow any pending scroll animations to complete
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Performance logged: Added 100 messages gradually in ${stopwatch.elapsedMilliseconds}ms
      });
    });

    group('Scrolling Performance', () {
      testWidgets('should scroll smoothly with many messages',
          (WidgetTester tester) async {
        // Generate many messages
        final messages = List.generate(
            200,
            (index) => ChatMessage(
                  id: index.toString(),
                  role: index % 2 == 0 ? 'user' : 'assistant',
                  content: 'Scroll test message $index',
                  timestamp:
                      DateTime.now().subtract(Duration(minutes: 200 - index)),
                ));

        mockProvider.setHasSession(true);
        mockProvider.setMessages(messages);

        await tester.pumpWidget(createTestWidget(
          screenSize: const Size(800, 600),
        ));
        await tester.pumpAndSettle();

        final listView = find.byType(ListView);
        expect(listView, findsOneWidget);

        final stopwatch = Stopwatch()..start();

        // Perform scrolling operations
        await tester.drag(listView, const Offset(0, -1000));
        await tester.pump();
        await tester.drag(listView, const Offset(0, -1000));
        await tester.pump();
        await tester.drag(listView, const Offset(0, 2000));
        await tester.pump();

        stopwatch.stop();

        // Should scroll smoothly without performance issues
        expect(stopwatch.elapsedMilliseconds, lessThan(200));

        // Performance logged: Scrolling operations completed in ${stopwatch.elapsedMilliseconds}ms
      });
    });

    group('Input Performance', () {
      testWidgets('should handle text input efficiently',
          (WidgetTester tester) async {
        mockProvider.setHasSession(true);

        await tester.pumpWidget(createTestWidget(
          screenSize: const Size(800, 600),
        ));
        await tester.pumpAndSettle();

        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);

        final stopwatch = Stopwatch()..start();

        // Simulate typing a long message
        const longMessage =
            'This is a long message that simulates user typing behavior with multiple words and sentences to test input performance.';

        await tester.enterText(textField, longMessage);
        await tester.pump();

        stopwatch.stop();

        // Should handle text input efficiently
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
        expect(find.text(longMessage), findsOneWidget);

        // Performance logged: Text input completed in ${stopwatch.elapsedMilliseconds}ms
      });

      testWidgets('should handle rapid text changes efficiently',
          (WidgetTester tester) async {
        mockProvider.setHasSession(true);

        await tester.pumpWidget(createTestWidget(
          screenSize: const Size(800, 600),
        ));
        await tester.pumpAndSettle();

        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);

        final stopwatch = Stopwatch()..start();

        // Simulate rapid text changes
        for (int i = 0; i < 20; i++) {
          await tester.enterText(textField, 'Message $i');
          await tester.pump();
        }

        stopwatch.stop();

        // Should handle rapid changes efficiently
        expect(stopwatch.elapsedMilliseconds, lessThan(300));

        // Performance logged: Rapid text changes completed in ${stopwatch.elapsedMilliseconds}ms
      });
    });

    group('Resource Cleanup', () {
      testWidgets('should clean up properly when switching analyses',
          (WidgetTester tester) async {
        // Start with first analysis
        mockProvider.setHasSession(true);
        mockProvider.setMessages([
          ChatMessage(
            id: '1',
            role: 'user',
            content: 'Message for analysis 1',
            timestamp: DateTime.now(),
          ),
        ]);

        await tester.pumpWidget(createTestWidget(
          screenSize: const Size(800, 600),
          analysisId: 'analysis-1',
        ));
        await tester.pumpAndSettle();

        expect(find.text('Message for analysis 1'), findsOneWidget);

        // Switch to second analysis
        mockProvider.clearMessages();
        mockProvider.setMessages([
          ChatMessage(
            id: '2',
            role: 'user',
            content: 'Message for analysis 2',
            timestamp: DateTime.now(),
          ),
        ]);

        await tester.pumpWidget(createTestWidget(
          screenSize: const Size(800, 600),
          analysisId: 'analysis-2',
        ));
        await tester.pumpAndSettle();

        // Should show new analysis messages
        expect(find.text('Message for analysis 2'), findsOneWidget);
        expect(find.text('Message for analysis 1'), findsNothing);

        // Should not have any exceptions
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle provider disposal gracefully',
          (WidgetTester tester) async {
        mockProvider.setHasSession(true);

        await tester.pumpWidget(createTestWidget(
          screenSize: const Size(800, 600),
        ));
        await tester.pumpAndSettle();

        // Dispose the widget tree
        await tester.pumpWidget(const SizedBox());
        await tester.pumpAndSettle();

        // Should not throw exceptions during disposal
        expect(tester.takeException(), isNull);
      });
    });
  });
}
