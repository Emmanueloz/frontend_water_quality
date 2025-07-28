import 'package:dio/dio.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/meter_records_response.dart';
import 'package:frontend_water_quality/domain/repositories/meter_records_repo.dart';

class MeterRecordsRepoImpl implements MeterRecordsRepo {
  final Dio _dio;

  MeterRecordsRepoImpl(this._dio);
  @override
  Future<Result<MeterRecordsResponse>> fetchMeterRecords(String userToken, String workspaceId, String meterId) async{
    // TODO: implement fetchMeterRecords
    try {
      final response = await _dio.get(
        '/meters/records/$workspaceId/$meterId/',
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      if (response.statusCode != 200) {
        return Result.failure('Error: codigo ${response.statusCode}');
      }

      return Result.success(MeterRecordsResponse.fromJson(response.data));
    } catch (e) {
      return Result.failure(e.toString());
    }

  }
}