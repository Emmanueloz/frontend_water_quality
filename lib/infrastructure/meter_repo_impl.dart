import 'package:dio/dio.dart';
import 'package:frontend_water_quality/core/enums/storage_key.dart';
import 'package:frontend_water_quality/core/interface/response/base_response.dart';
import 'package:frontend_water_quality/core/interface/response/meter_response.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/meter_model.dart';
import 'package:frontend_water_quality/domain/repositories/meter_repo.dart';
import 'package:frontend_water_quality/infrastructure/local_storage_service.dart';

class MeterRepoImpl implements MeterRepo {
  final Dio _dio;

  MeterRepoImpl(this._dio);
  String? token;

  Future<String> _loadToken() async {
    token = await LocalStorageService.get(StorageKey.token);
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
    return token ?? 'no-token';
  }

  @override
  Future<Result<BaseResponse>> add(
      String workspaceId, Meter meter) async {
    try {
      final token = await _loadToken();
      final response = await _dio.post(
        '/meters/$workspaceId/',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: meter.toJson(),
      );
      return Result.success(BaseResponse.fromJson(response.data));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<BaseResponse>> update(
      String workspaceId, String meterId, Meter meter) async {
    try {
      final token = await _loadToken();

      final response = await _dio.put(
        '/meters/$workspaceId/$meterId/',
        data: meter.toJson(),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return Result.success(BaseResponse.fromJson(response.data));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<BaseResponse>> delete(
      String workspaceId, String owner, String meterId) async {
    try {
      final token = await _loadToken();
      final response = await _dio.delete(
        '/meters/$workspaceId/$meterId/',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return Result.success(BaseResponse.fromJson(response.data));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<MeterResponse>> getList(String workspaceId) async {
    try {
      final token = await _loadToken();
      final response = await _dio.get('/meters/$workspaceId/',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ));
      return Result.success(MeterResponse.fromJson(response.data));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<MeterResponse>> get(
      String workspaceId, String meterId) async {
    try {
      final token = await _loadToken();
      final response = await _dio.get('/meters/$workspaceId/$meterId/',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ));
      return Result.success(MeterResponse.fromJson(response.data));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<bool>> isActive(
      String workspaceId, String owner, String meterId) async {
    try {
      final response =
          await _dio.get('/workspaces/$workspaceId/meters/$meterId/is_active/');
      final data = response.data;
      // Suponemos que la respuesta es {"is_active": true}
      return Result.success(data['is_active'] == true);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
