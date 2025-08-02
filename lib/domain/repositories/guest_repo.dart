import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/guests.dart';

abstract class GuestRepository {
  Future<Result<List<Guest>>> listGuests(String userToken, String workspaceId);
  Future<Result<Guest>> inviteGuest(String userToken, String workspaceId, String email, String role);
  Future<Result<Guest>> updateGuestRole(String userToken, String workspaceId, String guestId, String role);
  Future<Result<bool>> deleteGuest(String userToken, String workspaceId, String guestId);
}
