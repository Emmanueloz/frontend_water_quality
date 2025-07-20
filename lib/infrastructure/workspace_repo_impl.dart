import 'package:dio/dio.dart';
import 'package:frontend_water_quality/core/interface/response/base_response.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/workspace.dart';
import 'package:frontend_water_quality/domain/repositories/workspace_repo.dart';

class WorkspaceRepoImpl implements WorkspaceRepo {
  final Dio _dio;

  WorkspaceRepoImpl(this._dio);

  @override
  Future<Result<BaseResponse>> create(String userToken, Workspace workspace) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Result<BaseResponse>> delete(String userToken, String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Workspace>>> getAll(String userToken) {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<Result<Workspace>> getById(String userToken, String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Workspace>>> getFullAll(String userToken) {
    // TODO: implement getFullAll
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Workspace>>> getShared(String userToken) {
    // TODO: implement getShared
    throw UnimplementedError();
  }

  @override
  Future<Result<BaseResponse>> update(String userToken, Workspace workspace) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
