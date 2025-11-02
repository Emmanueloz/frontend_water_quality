import 'package:frontend_water_quality/core/enums/notification_status.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/notification_model.dart';

abstract class NotificationRepository {
  Future<Result<List<NotificationModel>>> listNotifications(
      String userToken, bool isRead, NotificationStatus status);
  Future<Result<NotificationModel>> getNotificationDetails(String userToken, String notificationId);
  Future<Result<String>> changeStatus(
      String userToken, String notificationId, NotificationStatus status);

}
