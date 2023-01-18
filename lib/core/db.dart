import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DBController {
  static Future<bool> save({required String tag, required String value}) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(tag, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>?> get({required String tag}) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final result = prefs.getString(tag);

      if (result == null) return null;

      return jsonDecode(result);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> delete({required String tag}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(tag);
    } catch (e) {
      return false;
    }
  }
}
