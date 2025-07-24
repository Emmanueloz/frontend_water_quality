import 'package:frontend_water_quality/core/enums/storage_key.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  static bool _initialized = false;

  // Inicializar Hive según plataforma
  static Future<void> init() async {
    if (_initialized) return;
    if (!kIsWeb) {
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
    (await _box).put(key.name, value);
  }

  // Consultar valor
  static Future<String?> get(StorageKey key) async {
    try {
      return (await _box).get(key.name, defaultValue: null);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Eliminar valor
  static Future<void> remove(StorageKey key) async {
    await (await _box).delete(key.name);
  }
}
