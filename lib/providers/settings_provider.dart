import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingsProvider extends ChangeNotifier{
  SharedPreferences? _pref;
  bool _darkTheme = true;
  bool get darkTheme => _darkTheme;

  SettingsProvider() {
    _loadFromPrefs();
    notifyListeners();
  }

  saveSetting(String key, bool value){
    _pref?.setBool(key, value);
    _darkTheme = _pref?.getBool("dark") ?? true;
    notifyListeners();
  }
  
  bool? getSetting(String key) {
    getPrefs();
    return _pref?.getBool(key);
  }

  getPrefs() async{
    await initPrefs();
  }

  initPrefs() async {
    _pref ??= await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await initPrefs();
    _darkTheme = _pref?.getBool("dark") ?? true;
    notifyListeners();
  }
}
