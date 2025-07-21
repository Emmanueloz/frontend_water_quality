import 'package:frontend_water_quality/core/interface/response/base_response.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/workspace.dart';

abstract class WorkspaceRepo {
  Future<Result<Workspace>> getById(String userToken, String id);
  Future<Result<BaseResponse>> create(String userToken, Workspace workspace);
  Future<Result<BaseResponse>> update(String userToken, Workspace workspace);
  Future<Result<BaseResponse>> delete(String userToken, String id);
  Future<Result<List<Workspace>>> getAll(String userToken);
  Future<Result<List<Workspace>>> getFullAll(String userToken);
  Future<Result<List<Workspace>>> getShared(String userToken);
}
