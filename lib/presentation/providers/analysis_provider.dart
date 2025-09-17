import 'package:dio/dio.dart';
import 'package:frontend_water_quality/domain/models/analysis/average.dart';
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
        status: "saved",
        type: "average",
        createdAt: DateTime.tryParse("2025-09-09 21:53:35.501831"),
        updatedAt: DateTime.tryParse("2025-09-09 21:53:38.586538"),
      ),
    ];
  }
}
