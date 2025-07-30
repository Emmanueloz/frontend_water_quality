import 'package:frontend_water_quality/domain/models/meter_model.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/core/interface/response/base_response.dart';

abstract class MeterRepo {
  Future<Result<Meter>> getById(String userToken, String idWorkspace, String idMeter);
  Future<Result<BaseResponse>> create(String userToken, String idWorkspace, Meter meter);
  Future<Result<BaseResponse>> update(String userToken,  String idWorkspace, Meter meter);
  Future<Result<BaseResponse>> delete(String userToken, String idWorkspace, String id);
  Future<Result<List<Meter>>> getAll(String userToken, String idWorkspace);
} 