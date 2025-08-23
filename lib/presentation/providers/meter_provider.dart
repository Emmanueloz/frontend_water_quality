import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/meter_model.dart';
import 'package:frontend_water_quality/domain/repositories/meter_repo.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';

class MeterProvider {
  final MeterRepo _meterRepo;
  AuthProvider? _authProvider;

  MeterProvider(this._meterRepo, this._authProvider);

  void setAuthProvider(AuthProvider? provider) {
    _authProvider = provider;
  }

  Future<Result<Meter>> getMeterById(String idWorkspace, String idMeter) async {
    if (_authProvider?.token == null)
      return Result.failure("User not authenticated");

    try {
      final result =
          await _meterRepo.getById(_authProvider!.token!, idWorkspace, idMeter);
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<List<Meter>>> getMeters(String idWorkspace) async {
    if (_authProvider?.token == null)
      return Result.failure("User not authenticated");

    try {
      final result =
          await _meterRepo.getAll(_authProvider!.token!, idWorkspace);
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<String?> createMeter(String idWorkspace, Meter meter) async {
    if (_authProvider?.token == null) return "User not authenticated";

    try {
      final result =
          await _meterRepo.create(_authProvider!.token!, idWorkspace, meter);
      return result.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateMeter(String idWorkspace, Meter meter) async {
    if (_authProvider?.token == null) return "User not authenticated";

    try {
      final result =
          await _meterRepo.update(_authProvider!.token!, idWorkspace, meter);
      return result.message;
    } catch (e) {
      return e.toString();
    }
  }
}
