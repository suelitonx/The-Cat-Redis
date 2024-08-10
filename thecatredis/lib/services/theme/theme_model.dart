import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModel with ChangeNotifier {
  //Variável privada que armazena o tema escuro
  bool _isDarkMode = false;

  //Método getter que retorna o tema escuro
  bool get isDarkMode => _isDarkMode;

  //Variável privada que armazena a instância da classe ThemeModel
  static final ThemeModel _instance = ThemeModel._();

  //Método getter que retorna a instância da classe ThemeModel
  static ThemeModel get instance => _instance;

  //Construtor privado da classe ThemeModel
  ThemeModel._() {
    //Inicializa o tema escuro
    Future<void>.delayed(Duration.zero, () async {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('dark') ?? false;
      notifyListeners();
    });
  }

  //Método que alterna o tema
  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    await saveTheme(_isDarkMode);
  }

  //Método que salva o tema no SharedPreferences
  Future<void> saveTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('dark', isDarkMode);
  }
}
