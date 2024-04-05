import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class LocalDB {
  static late SharedPreferences _preferences;
  static Future<SharedPreferences> init() async =>
      _preferences = await SharedPreferences.getInstance();

  static const String _count = 'Count-Key';

  static Future<void> setCount(int value) async {
    log('count: $value');
    final SharedPreferences prefer = await SharedPreferences.getInstance();
    await prefer.setInt(_count, value);
  }

  static Future<int?> count() async {
    final SharedPreferences prefer = await SharedPreferences.getInstance();
    prefer.getInt(_count);
  }
}
