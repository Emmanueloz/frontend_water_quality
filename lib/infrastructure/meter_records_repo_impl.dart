// lib/infrastructure/meter_records_repo_impl.dart
import 'package:dio/dio.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/meter_records_response.dart';
import 'package:frontend_water_quality/domain/repositories/meter_records_repo.dart';

class MeterRecordsRepoImpl implements MeterRecordsRepo {
  final Dio _dio;

  MeterRecordsRepoImpl(this._dio);

  @override
  Future<Result<MeterRecordsResponse>> fetchMeterRecords(
    String userToken,
    String workspaceId,
    String meterId, {
    DateTime? startDate,
    DateTime? endDate,
    String? lastId,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};

      if (startDate != null) {
        queryParams['start_date'] =
            '${startDate.toIso8601String().split('T')[0]} 00:00:00';
      }
      if (endDate != null) {
        queryParams['end_date'] =
            '${endDate.toIso8601String().split('T')[0]} 23:59:59';
      }
      if (lastId != null) {
        queryParams['last_id'] = lastId;
      }

      final response = await _dio.get(
        '/meters/records/$workspaceId/$meterId/',
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      if (response.statusCode != 200) {
        return Result.failure('Error: código ${response.statusCode}');
      }

      final recordsData = response.data['records'];
      if (recordsData == null || (recordsData is List && recordsData.isEmpty)) {
        return Result.failure('No records found');
      }

      return Result.success(MeterRecordsResponse.fromJson(recordsData));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
