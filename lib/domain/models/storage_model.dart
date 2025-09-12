import 'package:frontend_water_quality/domain/models/record_models.dart';
import 'package:frontend_water_quality/domain/models/user.dart';

class StorageModel {
  final String? token;
  final String? workspaceId;
  final String? meterId;
  final User? user;
  final RecordResponse? lastRecords;

  StorageModel({
    this.token,
    this.workspaceId,
    this.meterId,
    this.user,
    this.lastRecords,
  });
}
