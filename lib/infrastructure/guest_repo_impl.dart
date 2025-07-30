// infrastructure/guest_repository_impl.dart
import 'package:dio/dio.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/guests.dart';
import 'package:frontend_water_quality/domain/repositories/guest_repo.dart';

class GuestRepositoryImpl implements GuestRepository {
  final Dio _dio;

  GuestRepositoryImpl(this._dio);

  @override
  Future<Result<List<Guest>>> listGuests(String workspaceId) async {
    try {
      print('GuestRepositoryImpl: listGuests called for workspaceId=$workspaceId');
      
      // Verificar si el token está configurado
      final token = _dio.options.headers['Authorization'];
      print('GuestRepositoryImpl: Authorization header = $token');
      
      final response = await _dio.get('/workspaces/$workspaceId/guest/');
      
      print('GuestRepositoryImpl: listGuests response status=${response.statusCode}');
      
      if (response.statusCode != 200) {
        print('GuestRepositoryImpl: listGuests error status=${response.statusCode}');
        if (response.statusCode == 403) {
          return Result.failure('No tienes permisos para ver los invitados de este workspace');
        }
        return Result.failure('Error al obtener la lista de invitados');
      }

      // Debug: Imprimir el formato de respuesta
      print('Response data type: ${response.data.runtimeType}');
      print('Response data: ${response.data}');

      // Manejar diferentes formatos de respuesta
      List<dynamic> guestsData;
      
      if (response.data is List) {
        // Si la respuesta es directamente una lista
        guestsData = response.data as List<dynamic>;
        print('Response is List with ${guestsData.length} items');
      } else if (response.data is Map<String, dynamic>) {
        // Si la respuesta es un objeto con una propiedad 'data' o 'guests'
        final data = response.data as Map<String, dynamic>;
        print('Response is Map with keys: ${data.keys.toList()}');
        
        if (data.containsKey('data') && data['data'] is List) {
          guestsData = data['data'] as List<dynamic>;
          print('Found data key with ${guestsData.length} items');
        } else if (data.containsKey('guests') && data['guests'] is List) {
          guestsData = data['guests'] as List<dynamic>;
          print('Found guests key with ${guestsData.length} items');
        } else if (data.containsKey('results') && data['results'] is List) {
          guestsData = data['results'] as List<dynamic>;
          print('Found results key with ${guestsData.length} items');
        } else {
          // Si no encontramos una lista, intentar convertir el objeto en una lista
          guestsData = [data];
          print('Converting single object to list');
        }
      } else {
        print('Unknown response format: ${response.data.runtimeType}');
        return Result.failure('Formato de respuesta no válido');
      }

      final guests = guestsData.map((e) {
        print('Parsing guest JSON: $e');
        final guest = Guest.fromJson(e);
        print('Parsed guest: $guest');
        return guest;
      }).toList();
      print('Parsed ${guests.length} guests');
      
      // Debug: Imprimir información de cada invitado
      for (int i = 0; i < guests.length; i++) {
        final guest = guests[i];
        print('Guest $i: id=${guest.id}, name="${guest.name}", email=${guest.email}, role=${guest.role}');
      }
      
      return Result.success(guests);
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('DioException type: ${e.type}');
      print('DioException response: ${e.response?.data}');
      return Result.failure(_handleDioError(e));
    } catch (e) {
      print('Unexpected error: $e');
      return Result.failure('Error inesperado: $e');
    }
  }

  @override
  Future<Result<Guest>> inviteGuest(String workspaceId, String email, String role) async {
    try {
      print('Inviting guest: workspaceId=$workspaceId, email=$email, role=$role');
      
      final response = await _dio.post(
        '/workspaces/$workspaceId/guest/',
        data: {
          'guest': email,  // La API espera 'guest' en lugar de 'email'
          'rol': 'visitor', // Siempre usar 'visitor' como rol
        },
      );

      print('Invite response status: ${response.statusCode}');
      print('Invite response data: ${response.data}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorMessage = response.data['message'] ?? 'Error al invitar al invitado';
        print('Invite error: $errorMessage');
        return Result.failure(errorMessage);
      }

      // Debug: Imprimir el formato de respuesta
      print('Invite response data type: ${response.data.runtimeType}');
      print('Invite response data: ${response.data}');

      // Manejar diferentes formatos de respuesta
      Map<String, dynamic> guestData;
      
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        print('Invite response is Map with keys: ${data.keys.toList()}');
        
        if (data.containsKey('data')) {
          guestData = data['data'] as Map<String, dynamic>;
          print('Found data key in invite response');
        } else if (data.containsKey('guest')) {
          guestData = data['guest'] as Map<String, dynamic>;
          print('Found guest key in invite response');
        } else {
          guestData = data;
          print('Using response data directly');
        }
      } else {
        print('Unknown invite response format: ${response.data.runtimeType}');
        return Result.failure('Formato de respuesta no válido');
      }

      final guest = Guest.fromJson(guestData);
      print('Parsed guest: $guest');
      return Result.success(guest);
    } on DioException catch (e) {
      print('Invite DioException: ${e.message}');
      print('Invite DioException type: ${e.type}');
      print('Invite DioException response: ${e.response?.data}');
      return Result.failure(_handleDioError(e));
    } catch (e) {
      print('Invite unexpected error: $e');
      return Result.failure('Error inesperado: $e');
    }
  }

  @override
  Future<Result<Guest>> updateGuestRole(String workspaceId, String guestId, String role) async {
    try {
      print('Updating guest role: workspaceId=$workspaceId, guestId=$guestId, role=$role');
      
      final response = await _dio.put(
        '/workspaces/$workspaceId/guest/$guestId',
        data: {'rol': 'visitor'},  // Siempre usar 'visitor' como rol
      );

      print('Update response status: ${response.statusCode}');
      print('Update response data: ${response.data}');

      if (response.statusCode != 200) {
        final errorMessage = response.data['message'] ?? 'Error al actualizar el rol del invitado';
        print('Update error: $errorMessage');
        return Result.failure(errorMessage);
      }

      // Debug: Imprimir el formato de respuesta
      print('Update response data type: ${response.data.runtimeType}');
      print('Update response data: ${response.data}');

      // Manejar diferentes formatos de respuesta
      Map<String, dynamic> guestData;
      
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        print('Update response is Map with keys: ${data.keys.toList()}');
        
        if (data.containsKey('data')) {
          guestData = data['data'] as Map<String, dynamic>;
          print('Found data key in update response');
        } else if (data.containsKey('guest')) {
          guestData = data['guest'] as Map<String, dynamic>;
          print('Found guest key in update response');
        } else {
          guestData = data;
          print('Using update response data directly');
        }
      } else {
        print('Unknown update response format: ${response.data.runtimeType}');
        return Result.failure('Formato de respuesta no válido');
      }

      final guest = Guest.fromJson(guestData);
      print('Parsed updated guest: $guest');
      return Result.success(guest);
    } on DioException catch (e) {
      print('Update DioException: ${e.message}');
      print('Update DioException type: ${e.type}');
      print('Update DioException response: ${e.response?.data}');
      return Result.failure(_handleDioError(e));
    } catch (e) {
      print('Update unexpected error: $e');
      return Result.failure('Error inesperado: $e');
    }
  }

  @override
  Future<Result<bool>> deleteGuest(String workspaceId, String guestId) async {
    try {
      print('Deleting guest: workspaceId=$workspaceId, guestId=$guestId');
      
      // Intentar con DELETE primero
    try {
        final response = await _dio.delete(
          '/workspaces/$workspaceId/guest/$guestId',
        );

        print('Delete response status: ${response.statusCode}');
        print('Delete response data: ${response.data}');

        if (response.statusCode == 200 || response.statusCode == 204) {
          print('Delete successful');
          return Result.success(true);
        }
      } catch (e) {
        print('DELETE method failed, trying PUT with delete flag');
      }
      
      // Si DELETE falla, intentar con PUT y un flag de eliminación
      final response = await _dio.put(
        '/workspaces/$workspaceId/guest/$guestId',
        data: {'deleted': true},  // Flag para indicar eliminación
      );

      print('Delete (PUT) response status: ${response.statusCode}');
      print('Delete (PUT) response data: ${response.data}');

      if (response.statusCode == 200) {
        print('Delete (PUT) successful');
        return Result.success(true);
      }

      final errorMessage = response.data['message'] ?? 'Error al eliminar el invitado';
      print('Delete error: $errorMessage');
      return Result.failure(errorMessage);
    } on DioException catch (e) {
      print('Delete DioException: ${e.message}');
      print('Delete DioException type: ${e.type}');
      print('Delete DioException response: ${e.response?.data}');
      return Result.failure(_handleDioError(e));
    } catch (e) {
      print('Delete unexpected error: $e');
      return Result.failure('Error inesperado: $e');
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;
      
      switch (statusCode) {
        case 400:
          return data['message'] ?? 'Datos inválidos';
        case 401:
          return 'No autorizado';
        case 403:
          return 'Acceso denegado';
        case 404:
          return 'Recurso no encontrado';
        case 409:
          return 'El invitado ya existe';
        case 422:
          return data['message'] ?? 'Datos de entrada inválidos';
        case 500:
          return 'Error interno del servidor';
        default:
          return data['message'] ?? 'Error de conexión';
      }
    }
    
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return 'Tiempo de espera agotado';
    }
    
    if (e.type == DioExceptionType.connectionError) {
      return 'Error de conexión';
    }
    
    return e.message ?? 'Error desconocido';
  }
}
