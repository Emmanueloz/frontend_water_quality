import 'package:flutter/widgets.dart';
import 'package:frontend_water_quality/core/enums/storage_key.dart';
import 'package:frontend_water_quality/domain/models/meter_model.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/domain/repositories/meter_repo.dart';
import 'package:frontend_water_quality/core/interface/response/base_response.dart';
import 'package:frontend_water_quality/core/interface/response/meter_response.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/infrastructure/local_storage_service.dart';

class MeterProvider with ChangeNotifier {
  final MeterRepo _meterRepo;

  MeterProvider(this._meterRepo);

  bool isLoading = false;
  String? errorMessage;
  String? token;
  List<Meter> meters = [];
  bool isAuthenticated = false;
  User? user;

  Future<void> loadSettings() async {
    token = await LocalStorageService.get(StorageKey.token);
    isAuthenticated = token != null && token!.isNotEmpty;
    String? userString = await LocalStorageService.get(StorageKey.user);
    if (userString != null) {
      user = User.fromString(userString);
    }

    notifyListeners();
  }

  // Obtener lista de medidores
  Future<bool> getList(String workspaceId, String owner) async {
    isLoading = true;
    notifyListeners();
    final Result<MeterResponse> result = await _meterRepo.getList(
      workspaceId,
    );
    if (result.isSuccess) {
      errorMessage = null;
      // Procesar la respuesta para extraer la lista de medidores
      meters = result.value?.meters ?? [];
      print('Medidores cargados: ${meters.length}');
    } else {
      errorMessage = result.message;
      meters = [];
    }
    isLoading = false;
    notifyListeners();
    return result.isSuccess;
  }

  // Obtener un medidor específico
  Future<bool> get(String workspaceId, String owner, String meterId) async {
    isLoading = true;
    notifyListeners();
    final Result<MeterResponse> result = await _meterRepo.get(
      workspaceId,
      meterId,
    );
    if (result.isSuccess) {
      errorMessage = null;
      // Procesar la respuesta para extraer el medidor individual
      final meter = result.value?.meter;
      if (meter != null) {
        // Actualizar la lista con el medidor obtenido
        final index = meters.indexWhere((m) => m.id == meter.id);
        if (index != -1) {
          meters[index] = meter;
        } else {
          meters.add(meter);
        }
      }
    } else {
      errorMessage = result.message;
    }
    isLoading = false;
    notifyListeners();
    return result.isSuccess;
  }

  // Agregar un nuevo medidor
  Future<bool> add(String workspaceId, String owner, Meter meter) async {
    isLoading = true;
    notifyListeners();
    final Result<BaseResponse> result =
        await _meterRepo.add(workspaceId, meter);
    if (result.isSuccess) {
      errorMessage = null;
      await getList(workspaceId, owner);
    } else {
      errorMessage = result.message;
    }
    isLoading = false;
    notifyListeners();
    return result.isSuccess;
  }

  // Actualizar un medidor
  Future<bool> update(
      String workspaceId, String owner, String meterId, Meter meter) async {
    isLoading = true;
    notifyListeners();
    final Result<BaseResponse> result =
        await _meterRepo.update(workspaceId, meterId, meter);
    if (result.isSuccess) {
      errorMessage = null;
      await getList(workspaceId, owner);
    } else {
      errorMessage = result.message;
    }
    isLoading = false;
    notifyListeners();
    return result.isSuccess;
  }

  // Eliminar un medidor
  Future<bool> delete(String workspaceId, String owner, String meterId) async {
    isLoading = true;
    notifyListeners();
    final Result<BaseResponse> result =
        await _meterRepo.delete(workspaceId, owner, meterId);
    if (result.isSuccess) {
      errorMessage = null;
      await getList(workspaceId, owner);
    } else {
      errorMessage = result.message;
    }
    isLoading = false;
    notifyListeners();
    return result.isSuccess;
  }

  void cleanError() {
    if (errorMessage != null) {
      errorMessage = null;
      notifyListeners();
    }
  }
}
