import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../services/biometric_service.dart';

// Modelo de usuário para ambiente local e compatibilidade
class LocalUser {
  final String uid;
  final String? email;
  const LocalUser({required this.uid, this.email});
}

// Gerencia o estado de autenticação do usuário
class AuthProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final BiometricService _biometricService = BiometricService();

  static final Map<String, String> _localUsers = {};
  String? _localUserEmail;

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSessionUnlocked = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSessionUnlocked => _isSessionUnlocked;

  // Retorna o usuário logado (Firebase ou Local)
  dynamic get user {
    if (_firebaseService.currentUser != null) {
      return _firebaseService.currentUser;
    }
    if (_localUserEmail != null) {
      return LocalUser(uid: _localUserEmail!, email: _localUserEmail);
    }
    return null;
  }

  // Formata o identificador para e-mail padrão caso seja NIF
  String _formatEmail(String identifier) {
    final clean = identifier.trim();
    return clean.contains('@') ? clean : '$clean@empresa.com';
  }

  // Trata mensagem de erro e encerra o carregamento
  bool _handleAuthError(String message) {
    _errorMessage = message;
    _setLoading(false);
    return false;
  }

  // Registra usuário no banco local quando Firebase não responder
  bool _registerLocally(String email, String password) {
    if (_localUsers.containsKey(email)) {
      return _handleAuthError('Este e-mail/NIF já está cadastrado.');
    }
    _localUsers[email] = password;
    _setSession(email);
    return true;
  }

  // Realiza login no banco local
  bool _loginLocally(String email, String password) {
    if (_localUsers[email] == password) {
      _setSession(email);
      return true;
    }
    return _handleAuthError('NIF/E-mail ou senha incorretos.');
  }

  // Define a sessão ativa
  void _setSession(String email) {
    _localUserEmail = email;
    FirebaseService.localEmail = email;
    FirebaseService.localUid = 'local_$email';
    _isSessionUnlocked = true;
    _setLoading(false);
  }

  // Realiza cadastro de novo usuário
  Future<bool> register(String identifier, String password) async {
    _setLoading(true);
    final email = _formatEmail(identifier);
    try {
      await _firebaseService.registerWithEmail(email, password);
      _setSession(email);
      return true;
    } catch (_) {
      return _registerLocally(email, password);
    }
  }

  // Realiza login no sistema
  Future<bool> login(String identifier, String password) async {
    _setLoading(true);
    final email = _formatEmail(identifier);
    try {
      await _firebaseService.loginWithEmail(email, password);
      _setSession(email);
      return true;
    } catch (_) {
      return _loginLocally(email, password);
    }
  }

  // Realiza login biométrico
  Future<bool> loginWithBiometrics() async {
    _setLoading(true);
    try {
      bool ok = await _biometricService.authenticateUser();
      if (!ok) return _handleAuthError('Falha na verificação biométrica.');

      if (_localUserEmail != null || _firebaseService.currentUser != null) {
        _isSessionUnlocked = true;
        _setLoading(false);
        return true;
      }
      return _handleAuthError('Faça o primeiro login manual com NIF/E-mail.');
    } catch (_) {
      return _handleAuthError('Erro ao processar biometria.');
    }
  }

  // Encerra a sessão
  Future<void> logout() async {
    await _firebaseService.logout();
    _isSessionUnlocked = false;
    _localUserEmail = null;
    notifyListeners();
  }

  // Atualiza estado de carregamento
  void _setLoading(bool value) {
    _isLoading = value;
    if (value) _errorMessage = null;
    notifyListeners();
  }
}
