import 'package:frontend_water_quality/core/enums/storage_key.dart';
import 'package:hive/hive.dart';

class LocalStorageService {
  static Future<Box> get _box async => await Hive.openBox('settings');

  // Guardar valor
  static Future<void> save(StorageKey key, String value) async {
    (await _box).put(key.name, value);
  }

  // Consultar valor
  static Future<String?> get(StorageKey key) async {
    try {
      return (await _box).get(key.name);
    } catch (e) {
      // Manejo de errores si es necesario
      print(e.toString());
      return null;
    }
  }

  // Eliminar valor
  static Future<void> remove(StorageKey key) async {
    await (await _box).delete(key.name);
  }
}
