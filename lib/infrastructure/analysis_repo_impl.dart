import 'package:dio/dio.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/analysis/average/average.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/average_period.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/param_period.dart';
import 'package:frontend_water_quality/domain/models/analysis/correlation/correlation.dart';
import 'package:frontend_water_quality/domain/models/analysis/correlation/param_correlation.dart';
import 'package:frontend_water_quality/domain/models/analysis/parameters.dart';
import 'package:frontend_water_quality/domain/models/analysis/period/param_prediction.dart';
import 'package:frontend_water_quality/domain/models/analysis/period/prediction.dart';
import 'package:frontend_water_quality/domain/repositories/analysis_repo.dart';

class AnalysisRepoImpl extends AnalysisRepo {
  final Dio _dio;

  final String path = "/analysis";

  AnalysisRepoImpl(this._dio);

  @override
  Future<Result<String>> createAverages(String workspaceId, String meterId,
      String token, Parameters param) async {
    try {
      final response = await _dio.post(
        '$path/average/',
        data: {
          "identifier": {
            "workspace_id": workspaceId,
            "meter_id": meterId,
          },
          "range": param.toJson(),
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        return Result.failure('Error: codigo ${response.statusCode}');
      }

      return Result.success("Averages created successfully");
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<String>> createAveragesPeriod(String workspaceId,
      String meterId, String token, ParamPeriod param) async {
    try {
      final response = await _dio.post(
        '$path/average/period/',
        data: {
          "identifier": {
            "workspace_id": workspaceId,
            "meter_id": meterId,
          },
          "period": param.toJson(),
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        return Result.failure('Error: codigo ${response.statusCode}');
      }

      return Result.success("Averages created successfully");
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<String>> createCorrelation(String workspaceId, String meterId,
      String token, ParamCorrelation param) async {
    try {
      final response = await _dio.post(
        '$path/correlation/',
        data: {
          "identifier": {
            "workspace_id": workspaceId,
            "meter_id": meterId,
          },
          "correlation_params": param.toJson(),
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        return Result.failure('Error: codigo ${response.statusCode}');
      }

      return Result.success("Averages created successfully");
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<String>> createPrediction(String workspaceId, String meterId,
      String token, ParamPrediction param) async {
    try {
      final response = await _dio.post(
        '$path/prediction/',
        data: {
          "identifier": {
            "workspace_id": workspaceId,
            "meter_id": meterId,
          },
          "prediction_param": param.toJson(),
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        return Result.failure('Error: codigo ${response.statusCode}');
      }

      return Result.success("Averages created successfully");
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<String>> delete(String id, String token) async {
    try {
      final response = await _dio.delete(
        '$path/$id/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        return Result.failure('Error: codigo ${response.statusCode}');
      }

      return Result.success("Analysis deleted successfully");
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<List<Average>>> getAverages(
      String workspaceId, String meterId, String token) async {
    try {
      final response = await _dio.get(
        '$path/average/$workspaceId/$meterId/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        return Result.failure('Error: codigo ${response.statusCode}');
      }
      final Map<String, dynamic> data =
          response.data['result'] as Map<String, dynamic>;

      final List<Average> analysis = [];

      data.forEach(
        (key, value) => analysis.add(Average.fromJson(value, key)),
      );

      return Result.success(analysis);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<List<AveragePeriod>>> getAveragesPeriod(
      String workspaceId, String meterId, String token) async {
    try {
      final response = await _dio.get(
        '$path/average/period/$workspaceId/$meterId/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        return Result.failure('Error: codigo ${response.statusCode}');
      }
      final Map<String, dynamic> data =
          response.data['result'] as Map<String, dynamic>;

      final List<AveragePeriod> analysis = [];

      data.forEach(
        (key, value) => analysis.add(AveragePeriod.fromJson(value, key)),
      );

      return Result.success(analysis);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<List<Correlation>>> getCorrelations(
      String workspaceId, String meterId, String token) async {
    try {
      final response = await _dio.get(
        '$path/correlation/$workspaceId/$meterId/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        return Result.failure('Error: codigo ${response.statusCode}');
      }
      
      final Map<String, dynamic> data =
          response.data['result'] as Map<String, dynamic>;

      final List<Correlation> analysis = [];

      data.forEach(
        (key, value) => analysis.add(Correlation.fromJson(value, key)),
      );

      return Result.success(analysis);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<List<PredictionSensor>>> getPredictions(
      String workspaceId, String meterId, String token) async {
    try {
      final response = await _dio.get(
        '$path/prediction/$workspaceId/$meterId/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        return Result.failure('Error: codigo ${response.statusCode}');
      }
      final Map<String, dynamic> data =
          response.data['result'] as Map<String, dynamic>;

      final List<PredictionSensor> analysis = [];

      data.forEach(
        (key, value) => analysis.add(PredictionSensor.fromJson(value, key)),
      );

      return Result.success(analysis);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
