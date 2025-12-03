import 'package:frontend_water_quality/infrastructure/base_hive_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Servicio de almacenamiento local para registros (records)
/// Utiliza el box 'records' de Hive
class RecordStorage {
  static final BaseHiveStorage _storage = BaseHiveStorage('records');

  static Future<Box> get _box async {
    return await _storage.getBox();
  }

  static Future<void> save(String key, dynamic value) async {
    try {
      final box = await _box;
      await box.put(key, value);
    } catch (e) {
      print('RecordStorage.save error: ${e.toString()}');
    }
  }

  static Future<dynamic> get(String key) async {
    try {
      final box = await _box;
      return box.get(key);
    } catch (e) {
      print('RecordStorage.get error: ${e.toString()}');
      return null;
    }
  }

  static Future<Map<dynamic, dynamic>> getAll() async {
    try {
      final box = await _box;
      return box.toMap();
    } catch (e) {
      print('RecordStorage.getAll error: ${e.toString()}');
      return {};
    }
  }

  static Future<Iterable<dynamic>> getAllKeys() async {
    try {
      final box = await _box;
      return box.keys;
    } catch (e) {
      print('RecordStorage.getAllKeys error: ${e.toString()}');
      return [];
    }
  }

  /// Eliminar un registro
  /// [key] - Identificador del registro a eliminar
  static Future<void> remove(String key) async {
    try {
      final box = await _box;
      await box.delete(key);
    } catch (e) {
      print('RecordStorage.remove error: ${e.toString()}');
    }
  }

  /// Limpiar todos los registros del box
  static Future<void> clear() async {
    try {
      final box = await _box;
      await box.clear();
    } catch (e) {
      print('RecordStorage.clear error: ${e.toString()}');
    }
  }

  /// Verificar si existe un registro con la key especificada
  static Future<bool> contains(String key) async {
    try {
      final box = await _box;
      return box.containsKey(key);
    } catch (e) {
      print('RecordStorage.contains error: ${e.toString()}');
      return false;
    }
  }

  /// Obtener la cantidad de registros almacenados
  static Future<int> count() async {
    try {
      final box = await _box;
      return box.length;
    } catch (e) {
      print('RecordStorage.count error: ${e.toString()}');
      return 0;
    }
  }

  /// Cerrar el box (útil para limpieza)
  static Future<void> close() async {
    await _storage.closeBox();
  }
}
