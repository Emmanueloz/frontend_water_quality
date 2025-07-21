import 'package:dio/dio.dart';
import 'package:frontend_water_quality/core/interface/response/base_response.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/workspace.dart';
import 'package:frontend_water_quality/domain/repositories/workspace_repo.dart';

class WorkspaceRepoImpl implements WorkspaceRepo {
  final Dio _dio;

  WorkspaceRepoImpl(this._dio);

  @override
  Future<Result<BaseResponse>> create(
      String userToken, Workspace workspace) async {
    try {
      final response = await _dio.post(
        '/workspaces/',
        data: workspace.toJson(),
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
  Future<Result<BaseResponse>> delete(String userToken, String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Workspace>>> getAll(String userToken) async {
    try {
      final response = await _dio.get(
        '/workspaces/',
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      if (response.statusCode != 200) {
        return Result.failure('Error: codigo ${response.statusCode}');
      }

      final List<dynamic> data = response.data['data'] as List<dynamic>;
      final workspaces = data.map((item) => Workspace.fromJson(item)).toList();
      return Result.success(workspaces);
    } catch (e) {
      return Result.failure(e.toString());
    }
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
  Future<Result<List<Workspace>>> getShared(String userToken) async {
    try {
      final response = await _dio.get(
        '/workspaces/share/',
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      if (response.statusCode != 200) {
        return Result.failure('Error: codigo ${response.statusCode}');
      }

      final List<dynamic> data = response.data['data'] as List<dynamic>;
      final workspaces = data.map((item) => Workspace.fromJson(item)).toList();
      return Result.success(workspaces);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<BaseResponse>> update(String userToken, Workspace workspace) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
