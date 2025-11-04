
import 'package:flutter/widgets.dart';
import 'package:frontend_water_quality/core/enums/notification_status.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/notification_model.dart';
import 'package:frontend_water_quality/domain/repositories/notification_repo.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';

class NotificationProvider with ChangeNotifier{
  final NotificationRepository _notificationRepo;
  AuthProvider? _authProvider;

  NotificationProvider(this._notificationRepo, this._authProvider);

  void setAuthProvider(AuthProvider? provider) {
    _authProvider = provider;
  }

  Future<Result<List<NotificationModel>>> listNotifications(bool isRead, NotificationStatus status) async {
    if (_authProvider?.token == null) {
      return Result.failure("User not authenticated");
    }

    try {
      final result =
          await _notificationRepo.listNotifications(_authProvider!.token!, isRead, status);

      return result;
    } catch (e) {
      return Result.failure("Error fetching notifications: $e");
    }
  }

  Future<Result<NotificationModel>> getNotificationDetails(String notificationId) async {
    if (_authProvider?.token == null) {
      return Result.failure("User not authenticated");
    }

    try {
      final result =
          await _notificationRepo.getNotificationDetails(_authProvider!.token!, notificationId);

      return result;
    } catch (e) {
      return Result.failure("Error fetching notification details: $e");
    }
  }

  Future<Result<String>> changeStatus(String notificationId, NotificationStatus status) async {
    if (_authProvider?.token == null) {
      return Result.failure("User not authenticated");
    }

    try {
      final result =
          await _notificationRepo.changeStatus(_authProvider!.token!, notificationId, status);

      return result;
    } catch (e) {
      return Result.failure("Error changing notification status: $e");
    }
  }
}