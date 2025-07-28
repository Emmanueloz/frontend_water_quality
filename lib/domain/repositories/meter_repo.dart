import 'package:frontend_water_quality/domain/models/meter_model.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/core/interface/response/base_response.dart';
import 'package:frontend_water_quality/core/interface/response/meter_response.dart';

abstract class MeterRepo {
  Future<Result<MeterResponse>> getList(String workspaceId);
  Future<Result<MeterResponse>> get(String workspaceId, String meterId);
  Future<Result<BaseResponse>> add(String workspaceId, Meter meter);
  Future<Result<BaseResponse>> update(String workspaceId, String meterId, Meter meter);
  Future<Result<BaseResponse>> delete(String workspaceId, String owner, String meterId);
  Future<Result<bool>> isActive(String workspaceId, String owner, String meterId);
} 