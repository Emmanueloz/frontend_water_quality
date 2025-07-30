import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/guests.dart';

abstract class GuestRepository {
  Future<Result<List<Guest>>> listGuests(String workspaceId);
  Future<Result<Guest>> inviteGuest(String workspaceId, String email, String role);
  Future<Result<Guest>> updateGuestRole(String workspaceId, String guestId, String role);
  Future<Result<bool>> deleteGuest(String workspaceId, String guestId);
}
