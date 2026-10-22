// Gerenciamento de autenticação híbrida (Firebase + Fallback local)
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String uid;
  final String email;
  AppUser({required this.uid, required this.email});
}

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final _controller = StreamController<AppUser?>.broadcast();
  static final Map<String, String> _localUsers = {
    'chef@chefshelf.com': '123456',
  };
  static AppUser? _current;

  AuthService._internal() {
    _initListener();
  }

  // Escuta alterações do Firebase Auth
  void _initListener() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _current = AppUser(uid: user.uid, email: user.email ?? '');
        _controller.add(_current);
      } else if (_current == null || !_current!.uid.startsWith('local_')) {
        _controller.add(null);
      }
    });
  }

  // Stream com atualizações de autenticação
  Stream<AppUser?> get userChanges => _controller.stream;

  // Usuário atual
  AppUser? get currentUser => _current;

  // Realiza login no Firebase ou local
  Future<void> login(String email, String password) async {
    final cleanEmail = email.trim();
    if (_localUsers[cleanEmail] == password) {
      _setLocalSession(cleanEmail);
      return;
    }
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );
      if (cred.user != null) {
        _current = AppUser(uid: cred.user!.uid, email: cred.user!.email ?? cleanEmail);
        _controller.add(_current);
      }
    } catch (_) {
      if (_localUsers[cleanEmail] == password) {
        _setLocalSession(cleanEmail);
      } else {
        rethrow;
      }
    }
  }

  // Registra novo usuário no Firebase ou localmente
  Future<void> register(String email, String password) async {
    final cleanEmail = email.trim();
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );
      if (cred.user != null) {
        _current = AppUser(uid: cred.user!.uid, email: cred.user!.email ?? cleanEmail);
        _controller.add(_current);
      }
    } catch (_) {
      _localUsers[cleanEmail] = password;
      _setLocalSession(cleanEmail);
    }
  }

  // Inicia sessão local para testes e modo offline
  void _setLocalSession(String email) {
    _current = AppUser(
      uid: 'local_${email.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}',
      email: email,
    );
    _controller.add(_current);
  }

  // Envia e-mail de recuperação de senha
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } catch (_) {}
  }

  // Desconecta a conta atual
  Future<void> logout() async {
    _current = null;
    _controller.add(null);
    try {
      await _auth.signOut();
    } catch (_) {}
  }
}
