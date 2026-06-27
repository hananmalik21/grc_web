import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  HiveService._();

  static bool _initialized = false;

  static final Map<String, Box<dynamic>> _openBoxes = {};

  static Future<void> init() async {
    if (_initialized) return;
    await Hive.initFlutter();
    _initialized = true;
  }

  static bool get isInitialized => _initialized;

  static Future<Box<dynamic>> openBox(String name) async {
    if (!_initialized) {
      throw StateError('HiveService.init() must be called before openBox()');
    }
    _openBoxes[name] ??= await Hive.openBox(name);
    return _openBoxes[name]!;
  }

  static Future<void> closeBox(String name) async {
    final box = _openBoxes.remove(name);
    if (box != null && box.isOpen) {
      await box.close();
    }
  }

  static Future<void> closeAll() async {
    for (final name in _openBoxes.keys.toList()) {
      await closeBox(name);
    }
  }
}
