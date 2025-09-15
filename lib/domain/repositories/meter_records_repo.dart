import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/meter_records_response.dart';

abstract class MeterRecordsRepo {
  Future<Result<MeterRecordsResponse>> fetchMeterRecords(
    String userToken, 
    String workspaceId, 
    String meterId, {
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    int? limit,
  });
}
