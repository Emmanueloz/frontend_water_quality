import 'package:frontend_water_quality/domain/models/analysis/base_analysis.dart';
import 'package:frontend_water_quality/domain/models/analysis/period/data_pred_all.dart';
import 'package:frontend_water_quality/domain/models/analysis/period/data_pred_sensor.dart';
import 'package:frontend_water_quality/domain/models/analysis/period/param_prediction.dart';

class PredictionSensor extends BaseAnalysis<DataPredSensor, ParamPrediction> {}

class PredictionAll extends BaseAnalysis<DataPredAll, ParamPrediction> {}
