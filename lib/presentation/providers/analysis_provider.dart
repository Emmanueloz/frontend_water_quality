import 'package:dio/dio.dart';
import 'package:frontend_water_quality/domain/models/analysis/average.dart';
import 'package:frontend_water_quality/domain/models/analysis/data_average_all.dart';
import 'package:frontend_water_quality/domain/models/analysis/data_average_sensor.dart';
import 'package:frontend_water_quality/domain/models/analysis/parameters.dart';

class AnalysisProvider {
  final Dio _dio;

  AnalysisProvider(this._dio);

  Future<List<Average>> getAverage(
      String workspaceId, String meterId, String token) async {
    return [
      Average(
        id: "05f6f710-4483-c011-26f9-6d110cd555af",
        workspaceId: workspaceId,
        meterId: meterId,
        parameters: Parameters(
          startDate: DateTime.tryParse("2025-08-20 00:00:00"),
          endDate: DateTime.tryParse("2025-09-08 21:53:00"),
          sensor: "ph",
        ),
        data: DataAverageSensor(
          sensor: "ph",
          stats: Stats(
            average: 5.047702021503715,
            max: 15,
            min: 0.0007895208644093099,
          ),
        ),
        status: "saved",
        type: "average",
        createdAt: DateTime.tryParse("2025-09-09 21:52:39.387462"),
        updatedAt: DateTime.tryParse("2025-09-09 21:53:04.135930"),
      ),
      Average(
        id: "4d9405be-1960-efe3-a0e1-0f2bd3ab8dec",
        workspaceId: workspaceId,
        meterId: meterId,
        parameters: Parameters(
          startDate: DateTime.tryParse("2025-08-20 00:00:00"),
          endDate: DateTime.tryParse("2025-09-18 21:53:00"),
        ),
        data: DataAverageAll(
          result: [
            ResultAverage(
              average: 1478.4157853094275,
              max: 3500,
              min: 0.014457053746808057,
              sensor: "conductivity",
            ),
            ResultAverage(
              average: 5.06579072043262,
              max: 15,
              min: 0.0001220770079179978,
              sensor: "ph",
            ),
            ResultAverage(
              average: 17.399204175308967,
              max: 38,
              min: 0.0006186792622814297,
              sensor: "temperature",
            ),
            ResultAverage(
              average: 245.34736451593616,
              max: 620,
              min: 0,
              sensor: "tds",
            ),
            ResultAverage(
              average: 24.488921922661323,
              max: 70,
              min: 0.0010722281333697126,
              sensor: "turbidity",
            ),
          ],
        ),
        status: "saved",
        type: "average",
        createdAt: DateTime.tryParse("2025-09-17 01:58:50.086345"),
        updatedAt: DateTime.tryParse("2025-09-17 01:58:53.998612"),
      ),
      Average(
        id: "9f7c950c-f75e-7014-e360-fc4dc3fceeb8",
        workspaceId: workspaceId,
        meterId: meterId,
        parameters: Parameters(
          startDate: DateTime.tryParse("2025-08-20 00:00:00"),
          endDate: DateTime.tryParse("2025-09-08 21:53:00"),
          sensor: "tds",
        ),
        data: DataAverageSensor(
          sensor: "tds",
          stats: Stats(
            average: 247.03643649342865,
            max: 620,
            min: 0,
          ),
        ),
        status: "saved",
        type: "average",
        createdAt: DateTime.tryParse("2025-09-09 21:53:35.501831"),
        updatedAt: DateTime.tryParse("2025-09-09 21:53:38.586538"),
      ),
    ];
  }
}
