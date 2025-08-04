import 'package:flutter/widgets.dart';
import 'package:frontend_water_quality/domain/models/meter_model.dart';
import 'package:frontend_water_quality/domain/repositories/meter_repo.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';

class MeterProvider with ChangeNotifier {
  AuthProvider? _authProvider;
  final MeterRepo _meterRepo;
  MeterProvider(this._meterRepo, this._authProvider);

  List<Meter> meters = [];
  Meter? currentMeter;
  bool isLoading = false;
  bool isLoadingForm = false;
  bool recharge = true;
  String? errorMessage;
  String? errorMessageForm;

  void clean() {
    meters = [];
    currentMeter = null;
    isLoading = false;
    isLoadingForm = false;
    recharge = true;
    errorMessage = null;
    errorMessageForm = null;
  }

  void clearCurrentMeter() {
    currentMeter = null;
    errorMessageForm = null;
    notifyListeners();
  }

  void setAuthProvider(AuthProvider? provider) {
    _authProvider = provider;
  }

  Future<void> fetchMeter(String idWorkspace, String idMeter) async {
    if (_authProvider == null || _authProvider!.token == null) {
      errorMessage = "User not authenticated";
      notifyListeners();
      return;
    }

    isLoading = true;
    currentMeter = null;
    notifyListeners();

    try {
      final result =
          await _meterRepo.getById(_authProvider!.token!, idWorkspace, idMeter);
      if (!result.isSuccess) {
        errorMessage = result.message;
        return;
      }
      print("Fetched meter: $result");

      currentMeter = result.value;
      print("Current meter set: $currentMeter");
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMeters(String idWorkspace) async {
    if (_authProvider == null || _authProvider!.token == null) {
      errorMessage = "User not authenticated";
      notifyListeners();
      return;
    }

    if (!recharge) return;

    isLoading = true;
    notifyListeners();

    try {
      print("Fetching meters...");
      final result = await _meterRepo.getAll(_authProvider!.token!, idWorkspace);
      if (!result.isSuccess) {
        errorMessage = result.message;
        notifyListeners();
        return;
      }

      meters = result.value ?? [];
      errorMessage = null;


      if (currentMeter != null) {
        currentMeter = meters.firstWhere(
          (meter) => meter.id == currentMeter!.id,
          orElse: () => currentMeter!,
        );
      }
    } catch (e) {
      errorMessage = e.toString();
      print("Error fetching workspaces: $e");
    } finally {
      isLoading = false;
      recharge = false;
      notifyListeners();
    }
  }

  Future<bool> createMeter(String idWorkspace, Meter meter) async {
    if (_authProvider == null || _authProvider!.token == null) {
      errorMessageForm = "User not authenticated";
      notifyListeners();
      return false;
    }

    isLoadingForm = true;
    notifyListeners();

    try {
      print(meter.toJson());
      final result =
          await _meterRepo.create(_authProvider!.token!, idWorkspace, meter);

      print(result);
      if (!result.isSuccess) {
        errorMessageForm = result.message;
        return false;
      }

      recharge = true;
      errorMessageForm = null;
      isLoadingForm = false;
      notifyListeners();
      await fetchMeters(idWorkspace);
      return result.isSuccess;
    } catch (e) {
      errorMessageForm = e.toString();
      isLoadingForm = false;
      recharge = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateWorkspace(String idWorkspace, Meter meter) async {
    if (_authProvider == null || _authProvider!.token == null) {
      errorMessageForm = "User not authenticated";
      notifyListeners();
      return false;
    }

    isLoadingForm = true;
    notifyListeners();

    try {
      final result =
          await _meterRepo.update(_authProvider!.token!, idWorkspace, meter);

      if (!result.isSuccess) {
        errorMessageForm = result.message;
        return false;
      }

      recharge = true;
      errorMessageForm = null;
      isLoadingForm = false;
      notifyListeners();
      await fetchMeters(idWorkspace);
      if (currentMeter != null) {
        currentMeter = meter;
      }
      return result.isSuccess;
    } catch (e) {
      errorMessageForm = e.toString();
      isLoadingForm = false;
      recharge = false;
      notifyListeners();
      return false;
    }
  }
}
