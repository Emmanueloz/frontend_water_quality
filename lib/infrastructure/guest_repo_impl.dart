// infrastructure/guest_repository_impl.dart
import 'package:dio/dio.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/guests.dart';
import 'package:frontend_water_quality/domain/repositories/guest_repo.dart';

class GuestRepositoryImpl implements GuestRepository {
  final Dio _dio;

  GuestRepositoryImpl(this._dio);

  @override
  Future<Result<List<Guest>>> listGuests(String userToken, String workspaceId) async {
    try {
      print('GuestRepositoryImpl: listGuests called for workspaceId=$workspaceId');
      
      final response = await _dio.get(
        '/workspaces/$workspaceId/guest/',
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );
      
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
  Future<Result<Guest>> inviteGuest(String userToken, String workspaceId, String email, String role) async {
    try {
      print('Inviting guest: workspaceId=$workspaceId, email=$email, role=$role');
      
      final response = await _dio.post(
        '/workspaces/$workspaceId/guest/',
        data: {
          'guest': email,
          'rol': role,
        },
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      print('Invite response status: ${response.statusCode}');
      print('Invite response data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Manejar diferentes formatos de respuesta
        Map<String, dynamic> guestData;
        
        if (response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          
          // Si la respuesta tiene un campo 'guest', usar ese
          if (data.containsKey('guest') && data['guest'] is Map<String, dynamic>) {
            guestData = data['guest'] as Map<String, dynamic>;
            print('Found guest data in response.guest');
          } else {
            // Si no, usar toda la respuesta
            guestData = data;
            print('Using entire response as guest data');
          }
        } else {
          print('Unexpected response format: ${response.data.runtimeType}');
          return Result.failure('Formato de respuesta no válido');
        }
        
        final guest = Guest.fromJson(guestData);
        print('Parsed invited guest: $guest');
        return Result.success(guest);
      }

      return Result.failure('Error al invitar al invitado');
    } on DioException catch (e) {
      print('Invite DioException: ${e.message}');
      print('Invite response status: ${e.response?.statusCode}');
      print('Invite response data: ${e.response?.data}');
      return Result.failure(_handleDioError(e));
    } catch (e) {
      print('Invite unexpected error: $e');
      return Result.failure('Error inesperado al invitar: $e');
    }
  }

  @override
  Future<Result<Guest>> updateGuestRole(String userToken, String workspaceId, String guestId, String role) async {
    try {
      print('Updating guest role: workspaceId=$workspaceId, guestId=$guestId, role=$role');
      
      final response = await _dio.put(
        '/workspaces/$workspaceId/guest/$guestId',
        data: {
          'rol': role,
        },
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      print('Update response status: ${response.statusCode}');
      print('Update response data: ${response.data}');

      if (response.statusCode == 200) {
        // Manejar diferentes formatos de respuesta
        Map<String, dynamic> guestData;
        
        if (response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          
          // Si la respuesta tiene un campo 'guest', usar ese
          if (data.containsKey('guest') && data['guest'] is Map<String, dynamic>) {
            guestData = data['guest'] as Map<String, dynamic>;
            print('Found guest data in response.guest');
          } else {
            // Si no, usar toda la respuesta
            guestData = data;
            print('Using entire response as guest data');
          }
        } else {
          print('Unexpected response format: ${response.data.runtimeType}');
          return Result.failure('Formato de respuesta no válido');
        }
        
        final guest = Guest.fromJson(guestData);
        print('Parsed updated guest: $guest');
        return Result.success(guest);
      }

      return Result.failure('Error al actualizar el rol del invitado');
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
  Future<Result<bool>> deleteGuest(String userToken, String workspaceId, String guestId) async {
    try {
      print('Deleting guest: workspaceId=$workspaceId, guestId=$guestId');
      
      // Attempt DELETE first
      try {
        final response = await _dio.delete(
          '/workspaces/$workspaceId/guest/$guestId',
          options: Options(headers: {'Authorization': 'Bearer $userToken'}),
        );
        if (response.statusCode == 200 || response.statusCode == 204) {
          print('Delete successful with DELETE method');
          return Result.success(true);
        }
      } catch (e) {
        print('DELETE method failed, trying PUT with delete flag');
      }
      
      // If DELETE fails, try PUT with a delete flag
      final response = await _dio.put(
        '/workspaces/$workspaceId/guest/$guestId',
        data: {'deleted': true},
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      print('Delete response status: ${response.statusCode}');
      print('Delete response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return Result.success(true);
      }

      return Result.failure('Error al eliminar el invitado');
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

  String _handleDioError(DioException e) {
    if (e.response?.data is Map<String, dynamic>) {
      final data = e.response!.data as Map<String, dynamic>;
      if (data.containsKey('detail')) {
        if (data['detail'] is String) {
          return data['detail'] as String;
        } else if (data['detail'] is List) {
          final details = data['detail'] as List;
          if (details.isNotEmpty && details.first is Map<String, dynamic>) {
            final firstError = details.first as Map<String, dynamic>;
            if (firstError.containsKey('msg')) {
              return firstError['msg'] as String;
            }
          }
        }
      }
    }
    return 'Error de conexión: ${e.message}';
  }
}
