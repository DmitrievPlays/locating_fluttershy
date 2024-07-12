import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primarySwatch: Colors.teal,
  textTheme: Typography().black,
  scaffoldBackgroundColor: const Color(0xfff1f1f1),
  appBarTheme: const AppBarTheme(
    color: Colors.greenAccent,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  listTileTheme: const ListTileThemeData(textColor: Colors.black),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(
      color: Colors.blue,
    ),
  ),
);

ThemeData dark = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primarySwatch: Colors.blueGrey,
  scaffoldBackgroundColor: const Color(0xff0b0b0b),
  //bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: Colors.grey),
  cardTheme: const CardTheme(),
  listTileTheme:
      const ListTileThemeData(tileColor: Colors.grey, textColor: Colors.white),
);

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences? _pref;
  bool _darkTheme = true;
  bool get darkTheme => _darkTheme;

  ThemeNotifier() {
    _loadFromPrefs();
    notifyListeners();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    _pref ??= await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = _pref?.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _pref?.setBool(key, _darkTheme);
  }
}
