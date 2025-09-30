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
    // TODO: implement createAverages
    throw UnimplementedError();
  }

  @override
  Future<Result<String>> createAveragesPeriod(String workspaceId,
      String meterId, String token, ParamPeriod param) async {
    // TODO: implement createAveragesPeriod
    throw UnimplementedError();
  }

  @override
  Future<Result<String>> createCorrelation(String workspaceId, String meterId,
      String token, ParamCorrelation param) async {
    // TODO: implement createCorrelation
    throw UnimplementedError();
  }

  @override
  Future<Result<String>> createPrediction(String workspaceId, String meterId,
      String token, ParamPrediction param) async {
    // TODO: implement createPrediction
    throw UnimplementedError();
  }

  @override
  Future<Result<String>> delete(String id, String token) async {
    // TODO: implement delete
    throw UnimplementedError();
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
      final List<Average> averages = [];
      data.forEach(
        (key, value) => averages.add(Average.fromJson(value, key)),
      );
      return Result.success(averages);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<List<AveragePeriod>>> getAveragesPeriod(
      String workspaceId, String meterId, String token) async {
    // TODO: implement getAveragesPeriod
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Correlation>>> getCorrelations(
      String workspaceId, String meterId, String token) async {
    // TODO: implement getCorrelations
    throw UnimplementedError();
  }

  @override
  Future<Result<List<PredictionSensor>>> getPredictions(
      String workspaceId, String meterId, String token) async {
    // TODO: implement getPredictions
    throw UnimplementedError();
  }
}
