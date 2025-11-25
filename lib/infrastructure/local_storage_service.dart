import 'package:frontend_water_quality/core/enums/storage_key.dart';
import 'package:frontend_water_quality/domain/models/storage_model.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  static bool _initialized = false;

  // Inicializar Hive según plataforma
  static Future<void> init() async {
    if (_initialized) return;
    if (kIsWeb) {
      // Necesario para Flutter Web
      await Hive.initFlutter();
    } else {
      final dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
    }
    _initialized = true;
  }

  static Future<Box> get _box async {
    await init();
    return await Hive.openBox('settings');
  }

  // Guardar valor
  static Future<void> save(StorageKey key, String value) async {
    try {
      (await _box).put(key.name, value);
    } catch (e) {
      print('LocalStorageService.save error: '+e.toString());
    }
  }

  // Consultar valor
  static Future<String?> get(StorageKey key) async {
    try {
      return (await _box).get(key.name, defaultValue: null);
    } catch (e) {
      print('LocalStorageService.get error: '+e.toString());
      return null;
    }
  }

  static Future<StorageModel> getAll() async {
    try {
      String? token = await get(StorageKey.token);
      String? userString = await get(StorageKey.user);

      User? user;
      if (userString != null) {
        user = User.fromString(userString);
      }

      return StorageModel(
        token: token,
        user: user,
      );
    } catch (e) {
      print('LocalStorageService.getAll error: '+e.toString());

      return StorageModel();
    }
  }

  // Eliminar valor
  static Future<void> remove(StorageKey key) async {
    try {
      await (await _box).delete(key.name);
    } catch (e) {
      print('LocalStorageService.remove error: '+e.toString());
    }
  }
}
