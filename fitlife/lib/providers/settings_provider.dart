import 'package:flutter/material.dart';

// Mantém as preferências básicas do usuário para todo o app.
// Esse provider controla o nome de usuário e o modo de tema (claro/escuro).
class SettingsProvider with ChangeNotifier {
  String _username = '';
  bool _isDarkMode = false;

  // Retorna o nome do usuário, ou um rótulo padrão se nenhum nome foi definido.
  String get username => _username.isEmpty ? 'Usuário' : _username;

  bool get isDarkMode => _isDarkMode;

  void setUsername(String value) {
    _username = value.trim();
    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}
