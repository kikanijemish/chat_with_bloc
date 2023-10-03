

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsData {
  factory SharedPrefsData() {
    return _singleton;
  }
  SharedPrefsData._internal();
  static final SharedPrefsData _singleton = SharedPrefsData._internal();

  SharedPreferences? _storagePrefs;

  Future initializeSharedPreference() async {
    await SharedPreferences.getInstance().then((SharedPreferences prefs) async {
      _storagePrefs = prefs;
    });
  }

  void setIntData(String key, int value) {
    _storagePrefs?.setInt(key, value);
    // var getData =  _storagePrefs!.getInt(key);
  }

  int? getIntData(String key) {
    return _storagePrefs?.getInt(key);
  }

  void setStringData(String key, String value) {
    _storagePrefs?.setString(key, value);
  }

  String? getStringData(String key) {
    return _storagePrefs?.getString(key);
  }

  void setBoolData(String key, bool value) {
    _storagePrefs?.setBool(key, value);
  }

  bool? getBoolData(String key) {
    return _storagePrefs?.getBool(key);
  }

  void logOutClear() async {
    print("logOutClear is call");
    _storagePrefs!.clear();
    print("logOutClear is call after clear");
  }


}