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
    int? page,
    int? limit,
  }) async {
    try {
      // Construir query parameters
      final Map<String, dynamic> queryParams = {};
      
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String().split('T')[0];
      }
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String().split('T')[0];
      }
      if (page != null) {
        queryParams['page'] = page;
      }
      if (limit != null) {
        queryParams['limit'] = limit;
      }

      final response = await _dio.get(
        '/meters/records/$workspaceId/$meterId/',
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      if (response.statusCode != 200) {
        return Result.failure('Error: codigo ${response.statusCode}');
      }
      
      final recordsData = response.data['records'] as Map<String, dynamic>;
      if (recordsData.isEmpty) {
        return Result.failure('No records found');
      }
      
      return Result.success(MeterRecordsResponse.fromJson(recordsData));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
