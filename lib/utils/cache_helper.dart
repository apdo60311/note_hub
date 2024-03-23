import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHandler {
  static SharedPreferences? sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static void setBooleanData({required key, required bool value}) {
    sharedPreferences?.setBool(key, value);
  }

  static bool? getBooleanData({required key}) =>
      sharedPreferences?.getBool(key);

  static void setStringData({required key, required String value}) {
    sharedPreferences?.setString(key, value);
  }

  static String? getStringData({required key}) =>
      sharedPreferences?.getString(key);

  static void setIntData({required key, required int value}) {
    sharedPreferences?.setInt(key, value);
  }

  static Future clearData() async {
    await sharedPreferences?.clear();
  }

  static int? getintData({required key}) => sharedPreferences?.getInt(key);
}
