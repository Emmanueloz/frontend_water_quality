import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/alert.dart';

abstract class AlertRepository {
  Future<Result<List<Alert>>> listAlerts(String userToken, String workspaceId);
  Future<Result<Alert>> getAlertDetails(String userToken, String alertId);
  Future<Result<Alert>> createAlert(String userToken, Map<String, dynamic> alertData);
  Future<Result<Alert>> updateAlert(String userToken, String alertId, Map<String, dynamic> alertData);
  Future<Result<bool>> deleteAlert(String userToken, String alertId);
  Future<Result<List<Alert>>> getAlertNotifications(String userToken);
  Future<Result<bool>> markNotificationAsRead(String userToken, String notificationId);
} 