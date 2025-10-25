import 'package:dio/dio.dart';
import 'package:frontend_water_quality/core/interface/response/base_response.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/meter_model.dart';
import 'package:frontend_water_quality/domain/repositories/meter_repo.dart';
import 'package:frontend_water_quality/domain/models/pairing_response.dart';
import 'package:frontend_water_quality/core/errors/pairing_error.dart';

class MeterRepoImpl implements MeterRepo {
  final Dio _dio;

  MeterRepoImpl(this._dio);

  @override
  Future<Result<BaseResponse>> create(
      String userToken, String idWorkspace, Meter meter) async {
    try {
      final response = await _dio.post(
        '/meters/$idWorkspace/',
        data: meter.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Result.success(BaseResponse.fromJson(response.data));
      }

      return Result.failure('Error: codigo ${response.statusCode}');
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<BaseResponse>> delete(
      String userToken, String idWorkspace, String id) async {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Meter>>> getAll(
      String userToken, String idWorkspace) async {
    try {
      final url = '/meters/$idWorkspace/';

      final response = await _dio.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );
      print(response.data);

      if (response.statusCode != 200) {
        return Result.failure('Error: codigo ${response.statusCode}');
      }

      final List<dynamic> data = response.data['meters'] as List<dynamic>;
      final meters = data.map((item) => Meter.fromJson(item)).toList();
      return Result.success(meters);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<Meter>> getById(
      String userToken, String idWorkspace, String idMeter) async {
    try {
      final response = await _dio.get(
        '/meters/$idWorkspace/$idMeter/',
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      if (response.statusCode != 200) {
        return Result.failure('Error: codigo ${response.statusCode}');
      }

      final meter = Meter.fromJson(response.data['meter']);
      return Result.success(meter);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<BaseResponse>> update(
      String userToken, String idWorkspace, Meter meter) async {
    try {
      final response = await _dio.put(
        '/meters/$idWorkspace/${meter.id}/',
        data: meter.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Result.success(BaseResponse.fromJson(response.data));
      }

      return Result.failure('Error: codigo ${response.statusCode}');
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<bool>> validateToken(String userToken, String idWorkspace,
      String idMeter, String deviceToken) async {
    try {
      final response = await _dio.post(
        '/meters/$idWorkspace/pair/$idMeter/validate/',
        data: {'token': deviceToken},
        options: Options(
          headers: {'Authorization': 'Bearer $userToken'},
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      print(deviceToken);
      print(response.statusCode);

      if (response.statusCode == 200) {
        return Result.success(true);
      }

      throw PairingError.fromHttpStatus(
          response.statusCode ?? 0, response.data?.toString());
    } on PairingError catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      final pairingError = PairingError.fromException(e);
      return Result.failure(pairingError.message);
    }
  }

  @override
  Future<Result<PairingResponse>> pairMeter(
      String userToken, String idWorkspace, String idMeter) async {
    try {
      final response = await _dio.post(
        '/meters/$idWorkspace/pair/$idMeter/',
        options: Options(
          headers: {'Authorization': 'Bearer $userToken'},
          sendTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Result.success(PairingResponse.fromJson(response.data));
      }

      throw PairingError.fromHttpStatus(
          response.statusCode ?? 0, response.data?.toString());
    } on PairingError catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      final pairingError = PairingError.fromException(e);
      return Result.failure(pairingError.message);
    }
  }
}
