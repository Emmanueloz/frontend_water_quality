import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/ai/chat_session.dart';
import 'package:frontend_water_quality/domain/models/ai/chat_response.dart';
import 'package:frontend_water_quality/domain/models/ai/session_response.dart';

abstract class AiChatRepository {
  /// Creates a new AI chat session for the specified analysis
  /// Returns SessionResponse with session details and context
  Future<Result<SessionResponse>> createSession(
      String analysisId, String token);

  /// Sends a message to an existing chat session
  /// Returns ChatResponse with AI response and session_id
  Future<Result<ChatResponse>> sendMessage(
      String analysisId, String message, String token);

  /// Retrieves the complete chat session including message history
  /// Returns ChatSession with all messages and metadata
  Future<Result<ChatSession>> getSession(String analysisId, String token);
}
