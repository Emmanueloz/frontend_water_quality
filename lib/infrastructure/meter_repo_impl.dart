import 'package:dio/dio.dart';
import 'package:frontend_water_quality/core/interface/response/base_response.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/meter_model.dart';
import 'package:frontend_water_quality/domain/repositories/meter_repo.dart';

class MeterRepoImpl implements MeterRepo {
  final Dio _dio;

  MeterRepoImpl(this._dio);
  
  @override
  Future<Result<BaseResponse>> create(String userToken, String idWorkspace, Meter meter) async {
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
  Future<Result<BaseResponse>> delete(String userToken, String idWorkspace, String id) async {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Meter>>> getAll(String userToken, String idWorkspace) async {
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
  Future<Result<Meter>> getById(String userToken, String idWorkspace , String id) async {
    try {
      final response = await _dio.get(
        '/meters/$idWorkspace/$id/',
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );
      

      if (response.statusCode != 200) {
        return Result.failure('Error: codigo ${response.statusCode}');
      }

      final meter = Meter.fromJson(response.data['data']);
      return Result.success(meter);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
@override
Future<Result<BaseResponse>> update(String userToken, String idWorkspace, Meter meter) async {
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
}