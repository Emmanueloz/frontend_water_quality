import 'package:dio/dio.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/ai/chat_session.dart';
import 'package:frontend_water_quality/domain/models/ai/chat_response.dart';
import 'package:frontend_water_quality/domain/models/ai/chat_request.dart';
import 'package:frontend_water_quality/domain/models/ai/session_response.dart';
import 'package:frontend_water_quality/domain/repositories/ai_chat_repo.dart';

class AiChatRepositoryImpl extends AiChatRepository {
  final Dio _dio;
  final String _basePath = "/analysis/ai";

  AiChatRepositoryImpl(this._dio);

  @override
  Future<Result<SessionResponse>> createSession(
      String analysisId, String token) async {
    try {
      final response = await _dio.post(
        '$_basePath/$analysisId/session',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final sessionResponse = SessionResponse.fromJson(response.data);
        return Result.success(sessionResponse);
      } else if (response.statusCode == 401) {
        return Result.failure('Authentication failed. Please log in again.');
      } else if (response.statusCode == 403) {
        return Result.failure('Access denied to this analysis.');
      } else if (response.statusCode == 404) {
        return Result.failure('Analysis not found or not available for chat.');
      } else if (response.statusCode == 400) {
        return Result.failure('Analysis must be completed before using chat.');
      } else {
        return Result.failure(
            'Failed to create chat session. Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return Result.failure(
            'Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.connectionError) {
        return Result.failure('Connection error. Please try again.');
      } else {
        return Result.failure('Network error: ${e.message}');
      }
    } catch (e) {
      return Result.failure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Result<ChatResponse>> sendMessage(
      String analysisId, String message, String token) async {
    try {
      // Validate message before sending
      final chatRequest = ChatRequest(message: message);
      if (!chatRequest.isValid) {
        return Result.failure(chatRequest.validationError ?? 'Invalid message');
      }

      final response = await _dio.post(
        '$_basePath/$analysisId/chat',
        data: chatRequest.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final chatResponse = ChatResponse.fromJson(response.data);
        return Result.success(chatResponse);
      } else if (response.statusCode == 401) {
        return Result.failure('Authentication failed. Please log in again.');
      } else if (response.statusCode == 403) {
        return Result.failure('Access denied to this analysis.');
      } else if (response.statusCode == 404) {
        return Result.failure(
            'Chat session not found. Please start a new session.');
      } else if (response.statusCode == 400) {
        return Result.failure(
            'Invalid message or analysis not ready for chat.');
      } else {
        return Result.failure(
            'Failed to send message. Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return Result.failure(
            'Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.connectionError) {
        return Result.failure('Connection error. Please try again.');
      } else {
        return Result.failure('Network error: ${e.message}');
      }
    } catch (e) {
      return Result.failure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Result<ChatSession>> getSession(
      String analysisId, String token) async {
    try {
      final response = await _dio.get(
        '$_basePath/$analysisId/session',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final chatSession = ChatSession.fromJson(response.data);
        return Result.success(chatSession);
      } else if (response.statusCode == 401) {
        return Result.failure('Authentication failed. Please log in again.');
      } else if (response.statusCode == 403) {
        return Result.failure('Access denied to this analysis.');
      } else if (response.statusCode == 404) {
        return Result.failure('Chat session not found.');
      } else {
        return Result.failure(
            'Failed to retrieve chat session. Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return Result.failure(
            'Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.connectionError) {
        return Result.failure('Connection error. Please try again.');
      } else {
        return Result.failure('Network error: ${e.message}');
      }
    } catch (e) {
      return Result.failure('Unexpected error: ${e.toString()}');
    }
  }
}
