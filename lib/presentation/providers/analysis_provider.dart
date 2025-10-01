import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/analysis/average/average.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/average_period.dart';
import 'package:frontend_water_quality/domain/models/analysis/correlation/correlation.dart';
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
