import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Clase genérica base para manejar la inicialización de Hive
/// con diferentes boxes (tablas)
class BaseHiveStorage {
  static bool _hiveInitialized = false;
  final String boxName;
  Box? _boxInstance;

  BaseHiveStorage(this.boxName);

  /// Inicializar Hive según plataforma (solo una vez globalmente)
  static Future<void> initHive() async {
    if (_hiveInitialized) return;

    if (kIsWeb) {
      // Necesario para Flutter Web
      await Hive.initFlutter();
    } else {
      final dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
    }

    _hiveInitialized = true;
  }

  /// Obtener o abrir el box específico
  Future<Box> getBox() async {
    await initHive();

    if (_boxInstance != null && _boxInstance!.isOpen) {
      return _boxInstance!;
    }

    _boxInstance = await Hive.openBox(boxName);
    return _boxInstance!;
  }

  /// Cerrar el box (útil para limpieza)
  Future<void> closeBox() async {
    if (_boxInstance != null && _boxInstance!.isOpen) {
      await _boxInstance!.close();
      _boxInstance = null;
    }
  }
}
