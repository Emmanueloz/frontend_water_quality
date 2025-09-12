import 'package:flutter/foundation.dart';
import 'package:frontend_water_quality/core/enums/storage_key.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/meter_model.dart';
import 'package:frontend_water_quality/domain/repositories/meter_repo.dart';
import 'package:frontend_water_quality/infrastructure/local_storage_service.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';

class MeterProvider with ChangeNotifier {
  final MeterRepo _meterRepo;
  AuthProvider? _authProvider;

  // Flags para control de recarga
  final Map<String, bool> _shouldReloadList = {};
  final Map<String, bool> _shouldReloadMeter = {};

  MeterProvider(this._meterRepo, this._authProvider);

  // Getters para los flags
  bool shouldReloadList(String workspaceId) =>
      _shouldReloadList[workspaceId] ?? true;
  bool shouldReloadMeter(String workspaceId, String meterId) =>
      _shouldReloadMeter['$workspaceId-$meterId'] ?? true;

  // Métodos para marcar recargas
  void markListForReload(String workspaceId) {
    _shouldReloadList[workspaceId] = true;
    notifyListeners();
  }

  void markMeterForReload(String workspaceId, String meterId) {
    _shouldReloadMeter['$workspaceId-$meterId'] = true;
    notifyListeners();
  }

  // Métodos para confirmar recargas completadas
  void confirmListReloaded(String workspaceId) {
    _shouldReloadList.remove(workspaceId);
  }

  void confirmMeterReloaded(String workspaceId, String meterId) {
    _shouldReloadMeter.remove('$workspaceId-$meterId');
  }

  void setAuthProvider(AuthProvider? provider) {
    _authProvider = provider;
  }

  Future<Result<Meter>> getMeterById(String idWorkspace, String idMeter) async {
    if (_authProvider?.token == null) {
      return Result.failure("User not authenticated");
    }

    try {
      final result =
          await _meterRepo.getById(_authProvider!.token!, idWorkspace, idMeter);

      if (idWorkspace !=
          await LocalStorageService.get(StorageKey.workspaceId)) {
        LocalStorageService.save(StorageKey.workspaceId, idWorkspace);
      }

      if (idMeter != await LocalStorageService.get(StorageKey.meterId)) {
        LocalStorageService.save(StorageKey.meterId, idMeter);
      }

      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<List<Meter>>> getMeters(String idWorkspace) async {
    if (_authProvider?.token == null) {
      return Result.failure("User not authenticated");
    }

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
      if (result.isSuccess) {
        markListForReload(
            idWorkspace); // Marcar para recargar la lista después de crear
      }
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
      if (result.isSuccess) {
        markMeterForReload(idWorkspace, meter.id!); // Marcar medidor específico
        markListForReload(idWorkspace); // Marcar lista para actualizar
      }
      return result.message;
    } catch (e) {
      return e.toString();
    }
  }
}
