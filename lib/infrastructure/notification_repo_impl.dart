import 'package:dio/dio.dart';
import 'package:frontend_water_quality/core/enums/notification_status.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/notification_model.dart';
import 'package:frontend_water_quality/domain/repositories/notification_repo.dart';

class NotificationRepoImpl implements NotificationRepository {
  final Dio _dio;
  NotificationRepoImpl(this._dio);
  @override
  Future<Result<String>> changeStatus(String userToken, String notificationId,
      NotificationStatus status) async {
    try {
      final response = await _dio.put(
        '/alerts/notifications/$notificationId/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $userToken',
          },
        ),
        data: {
          'status': status.name,
        },
      );

      if (response.statusCode != 200) {
        return Result.failure('Error: codigo ${response.statusCode}');
      }
      return Result.success('Notificacion actualizada');
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<NotificationModel>> getNotificationDetails(
      String userToken, String notificationId) async {
    try {
      final response = await _dio.get(
        '/alerts/notifications/$notificationId/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $userToken',
          },
        ),
      );

      if (response.statusCode != 200) {
        return Result.failure('Error: codigo ${response.statusCode}');
      }
      final notification =
          NotificationModel.fromJson(response.data['notification']);
      return Result.success(notification);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<List<NotificationModel>>> listNotifications(
      String userToken, bool isRead, NotificationStatus status) async {
    try {
      final response = await _dio.get(
        '/alerts/notifications/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $userToken',
          },
        ),
        queryParameters: {
          'convert_timestamp': true,
          'read': isRead,
          'status': status.name,
        },
      );
      if (response.statusCode != 200) {
        return Result.failure('Error: codigo ${response.statusCode}');
      }
      final rawList = response.data['notifications'] as List<dynamic>?;
      final notifications = (rawList ?? <dynamic>[])
          .map((item) => NotificationModel.fromJson(
              Map<String, dynamic>.from(item as Map)))
          .toList();
      return Result.success(notifications);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
