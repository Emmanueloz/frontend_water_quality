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
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';

class AnalysisProvider {
  final AnalysisRepo _analysisRepo;
  AuthProvider? _authProvider;

  AnalysisProvider(this._analysisRepo, this._authProvider);

  void setAuthProvider(AuthProvider? provider) {
    _authProvider = provider;
  }

  Future<Result<String>> createAverages(
      String workspaceId, String meterId, Parameters param) async {
    if (_authProvider == null || _authProvider!.token == null) {
      return Result.failure("User not authenticated");
    }
    try {
      final result = await _analysisRepo.createAverages(
          workspaceId, meterId, _authProvider!.token!, param);

      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<String>> createAveragesPeriod(
      String workspaceId, String meterId, ParamPeriod param) async {
    if (_authProvider == null || _authProvider!.token == null) {
      return Result.failure("User not authenticated");
    }
    try {
      final result = await _analysisRepo.createAveragesPeriod(
          workspaceId, meterId, _authProvider!.token!, param);

      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<String>> createPrediction(
      String workspaceId, String meterId, ParamPrediction param) async {
    if (_authProvider == null || _authProvider!.token == null) {
      return Result.failure("User not authenticated");
    }
    try {
      final result = await _analysisRepo.createPrediction(
          workspaceId, meterId, _authProvider!.token!, param);

      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<String>> createCorrelation(
      String workspaceId, String meterId, ParamCorrelation param) async {
    if (_authProvider == null || _authProvider!.token == null) {
      return Result.failure("User not authenticated");
    }
    try {
      final result = await _analysisRepo.createCorrelation(
          workspaceId, meterId, _authProvider!.token!, param);

      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<List<Average>>> getAverage(
      String workspaceId, String meterId) async {
    if (_authProvider == null || _authProvider!.token == null) {
      return Result.failure("User not authenticated");
    }
    try {
      final result = await _analysisRepo.getAverages(
          workspaceId, meterId, _authProvider!.token!);

      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<String>> delete(String id) async {
    if (_authProvider == null || _authProvider!.token == null) {
      return Result.failure("User not authenticated");
    }
    try {
      final result = await _analysisRepo.delete(id, _authProvider!.token!);

      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<List<AveragePeriod>>> getAveragePeriod(
    String workspaceId,
    String meterId,
  ) async {
    if (_authProvider == null || _authProvider!.token == null) {
      return Result.failure("User not authenticated");
    }
    try {
      final result = await _analysisRepo.getAveragesPeriod(
          workspaceId, meterId, _authProvider!.token!);

      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<List<PredictionSensor>>> getPredictions(
    String workspaceId,
    String meterId,
  ) async {
    if (_authProvider == null || _authProvider!.token == null) {
      return Result.failure("User not authenticated");
    }
    try {
      final result = await _analysisRepo.getPredictions(
          workspaceId, meterId, _authProvider!.token!);

      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<List<Correlation>>> getCorrelations(
    String workspaceId,
    String meterId,
  ) async {
    if (_authProvider == null || _authProvider!.token == null) {
      return Result.failure("User not authenticated");
    }
    try {
      final result = await _analysisRepo.getCorrelations(
          workspaceId, meterId, _authProvider!.token!);

      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
