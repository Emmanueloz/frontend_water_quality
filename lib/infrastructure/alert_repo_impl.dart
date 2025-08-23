import 'package:dio/dio.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/alert.dart';
import 'package:frontend_water_quality/domain/repositories/alert_repo.dart';

class AlertRepositoryImpl implements AlertRepository {
  final Dio _dio;

  AlertRepositoryImpl(this._dio);

  String _handleDioError(DioException e) {
    if (e.response?.statusCode == 401) {
      return 'No autorizado. Por favor, inicie sesión nuevamente.';
    } else if (e.response?.statusCode == 404) {
      return 'Alerta no encontrada.';
    } else if (e.response?.statusCode == 403) {
      return 'No tiene permisos para realizar esta acción.';
    } else if (e.response?.statusCode == 422) {
      return 'Datos inválidos. Por favor, verifique la información.';
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return 'Tiempo de conexión agotado. Verifique su conexión a internet.';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return 'Tiempo de respuesta agotado. Intente nuevamente.';
    } else {
      return 'Error de conexión. Intente nuevamente.';
    }
  }

  @override
  Future<Result<List<Alert>>> listAlerts(String userToken, String workspaceId) async {
    try {
      print('Listing alerts for workspace: $workspaceId');
      
      final response = await _dio.get(
        '/alerts/',
        queryParameters: {'workspace_id': workspaceId},
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      print('List response status: ${response.statusCode}');
      print('List response data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> alertsData = response.data['alerts'] ?? response.data;
        final alerts = alertsData
            .map((json) => Alert.fromJson(json))
            .toList();
        
        print('Parsed ${alerts.length} alerts');
        return Result.success(alerts);
      }

      return Result.failure('Error al cargar las alertas');
    } on DioException catch (e) {
      print('List DioException: ${e.message}');
      print('List response status: ${e.response?.statusCode}');
      print('List response data: ${e.response?.data}');
      return Result.failure(_handleDioError(e));
    } catch (e) {
      print('List unexpected error: $e');
      return Result.failure('Error inesperado: $e');
    }
  }

  @override
  Future<Result<Alert>> getAlertDetails(String userToken, String alertId) async {
    try {
      print('Getting alert details: alertId=$alertId');
      
      final response = await _dio.get(
        '/alerts/$alertId/',
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      print('Details response status: ${response.statusCode}');
      print('Details response data: ${response.data}');

      if (response.statusCode == 200) {
        Map<String, dynamic> alertData;
        
        if (response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          
          if (data.containsKey('alert') && data['alert'] is Map<String, dynamic>) {
            alertData = data['alert'] as Map<String, dynamic>;
            print('Found alert data in response.alert');
          } else {
            alertData = data;
            print('Using entire response as alert data');
          }
        } else {
          print('Unexpected response format: ${response.data.runtimeType}');
          return Result.failure('Formato de respuesta no válido');
        }
        
        final alert = Alert.fromJson(alertData);
        print('Parsed alert details: $alert');
        return Result.success(alert);
      }

      return Result.failure('Error al obtener los detalles de la alerta');
    } on DioException catch (e) {
      print('Details DioException: ${e.message}');
      print('Details response status: ${e.response?.statusCode}');
      print('Details response data: ${e.response?.data}');
      return Result.failure(_handleDioError(e));
    } catch (e) {
      print('Details unexpected error: $e');
      return Result.failure('Error inesperado al obtener detalles: $e');
    }
  }

  @override
  Future<Result<Alert>> createAlert(String userToken, Map<String, dynamic> alertData) async {
    try {
      print('Creating alert: data=$alertData');
      print('Creating alert: all fields: ${alertData.keys.toList()}');
      
      final response = await _dio.post(
        '/alerts/',
        data: alertData,
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      print('Create response status: ${response.statusCode}');
      print('Create response data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        Map<String, dynamic> alertResponseData;
        
        if (response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          
          if (data.containsKey('alert') && data['alert'] is Map<String, dynamic>) {
            alertResponseData = data['alert'] as Map<String, dynamic>;
            print('Found alert data in response.alert');
          } else {
            alertResponseData = data;
            print('Using entire response as alert data');
          }
        } else {
          print('Unexpected response format: ${response.data.runtimeType}');
          return Result.failure('Formato de respuesta no válido');
        }
        
        final alert = Alert.fromJson(alertResponseData);
        print('Created alert: $alert');
        return Result.success(alert);
      }

      return Result.failure('Error al crear la alerta');
    } on DioException catch (e) {
      print('Create DioException: ${e.message}');
      print('Create response status: ${e.response?.statusCode}');
      print('Create response data: ${e.response?.data}');
      return Result.failure(_handleDioError(e));
    } catch (e) {
      print('Create unexpected error: $e');
      return Result.failure('Error inesperado al crear: $e');
    }
  }

  @override
  Future<Result<Alert>> updateAlert(String userToken, String alertId, Map<String, dynamic> alertData) async {
    try {
      print('Updating alert: alertId=$alertId, data=$alertData');
      print('Updating alert: all fields: ${alertData.keys.toList()}');
      
      final response = await _dio.put(
        '/alerts/$alertId/',
        data: alertData,
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      print('Update response status: ${response.statusCode}');
      print('Update response data: ${response.data}');

      if (response.statusCode == 200) {
        Map<String, dynamic> alertResponseData;
        
        if (response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          
          if (data.containsKey('alert') && data['alert'] is Map<String, dynamic>) {
            alertResponseData = data['alert'] as Map<String, dynamic>;
            print('Found alert data in response.alert');
          } else {
            alertResponseData = data;
            print('Using entire response as alert data');
          }
        } else {
          print('Unexpected response format: ${response.data.runtimeType}');
          return Result.failure('Formato de respuesta no válido');
        }
        
        final alert = Alert.fromJson(alertResponseData);
        print('Updated alert: $alert');
        return Result.success(alert);
      }

      return Result.failure('Error al actualizar la alerta');
    } on DioException catch (e) {
      print('Update DioException: ${e.message}');
      print('Update response status: ${e.response?.statusCode}');
      print('Update response data: ${e.response?.data}');
      return Result.failure(_handleDioError(e));
    } catch (e) {
      print('Update unexpected error: $e');
      return Result.failure('Error inesperado al actualizar: $e');
    }
  }

  @override
  Future<Result<bool>> deleteAlert(String userToken, String alertId) async {
    try {
      print('Deleting alert: alertId=$alertId');
      
      final response = await _dio.delete(
        '/alerts/$alertId/',
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      print('Delete response status: ${response.statusCode}');
      print('Delete response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Alert deleted successfully');
        return Result.success(true);
      }

      return Result.failure('Error al eliminar la alerta');
    } on DioException catch (e) {
      print('Delete DioException: ${e.message}');
      print('Delete response status: ${e.response?.statusCode}');
      print('Delete response data: ${e.response?.data}');
      return Result.failure(_handleDioError(e));
    } catch (e) {
      print('Delete unexpected error: $e');
      return Result.failure('Error inesperado al eliminar: $e');
    }
  }

  @override
  Future<Result<List<Alert>>> getAlertNotifications(String userToken) async {
    try {
      print('Getting alert notifications');
      
      final response = await _dio.get(
        '/alerts/notifications/',
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      print('Notifications response status: ${response.statusCode}');
      print('Notifications response data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> notificationsData = response.data['notifications'] ?? response.data;
        final notifications = notificationsData
            .map((json) => Alert.fromJson(json))
            .toList();
        
        print('Parsed ${notifications.length} alert notifications');
        return Result.success(notifications);
      }

      return Result.failure('Error al cargar las notificaciones de alertas');
    } on DioException catch (e) {
      print('Notifications DioException: ${e.message}');
      print('Notifications response status: ${e.response?.statusCode}');
      print('Notifications response data: ${e.response?.data}');
      return Result.failure(_handleDioError(e));
    } catch (e) {
      print('Notifications unexpected error: $e');
      return Result.failure('Error inesperado: $e');
    }
  }

  @override
  Future<Result<bool>> markNotificationAsRead(String userToken, String notificationId) async {
    try {
      print('Marking notification as read: notificationId=$notificationId');
      
      final response = await _dio.put(
        '/alerts/notifications/$notificationId/',
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      print('Mark as read response status: ${response.statusCode}');
      print('Mark as read response data: ${response.data}');

      if (response.statusCode == 200) {
        print('Notification marked as read successfully');
        return Result.success(true);
      }

      return Result.failure('Error al marcar la notificación como leída');
    } on DioException catch (e) {
      print('Mark as read DioException: ${e.message}');
      print('Mark as read response status: ${e.response?.statusCode}');
      print('Mark as read response data: ${e.response?.data}');
      return Result.failure(_handleDioError(e));
    } catch (e) {
      print('Mark as read unexpected error: $e');
      return Result.failure('Error inesperado al marcar como leída: $e');
    }
  }
} 