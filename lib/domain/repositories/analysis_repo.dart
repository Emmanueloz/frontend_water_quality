import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/analysis/average/average.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/average_period.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/param_period.dart';
import 'package:frontend_water_quality/domain/models/analysis/correlation/correlation.dart';
import 'package:frontend_water_quality/domain/models/analysis/correlation/param_correlation.dart';
import 'package:frontend_water_quality/domain/models/analysis/parameters.dart';
import 'package:frontend_water_quality/domain/models/analysis/period/param_prediction.dart';
import 'package:frontend_water_quality/domain/models/analysis/period/prediction.dart';

abstract class AnalysisRepo {
  Future<Result<String>> createAverages(
    String workspaceId,
    String meterId,
    String token,
    Parameters param,
  );

  Future<Result<List<Average>>> getAverages(
    String workspaceId,
    String meterId,
    String token,
  );

  Future<Result<String>> createAveragesPeriod(
    String workspaceId,
    String meterId,
    String token,
    ParamPeriod param,
  );
  Future<Result<List<AveragePeriod>>> getAveragesPeriod(
    String workspaceId,
    String meterId,
    String token,
  );

  Future<Result<String>> createPrediction(
    String workspaceId,
    String meterId,
    String token,
    ParamPrediction param,
  );
  Future<Result<List<PredictionSensor>>> getPredictions(
    String workspaceId,
    String meterId,
    String token,
  );

  Future<Result<String>> createCorrelation(
    String workspaceId,
    String meterId,
    String token,
    ParamCorrelation param,
  );
  Future<Result<List<Correlation>>> getCorrelations(
    String workspaceId,
    String meterId,
    String token,
  );

  Future<Result<String>> delete(
    String id,
    String token,
  );
}
