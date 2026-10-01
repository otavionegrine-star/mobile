import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Serviço de integração com o Firebase Authentication e Firestore
class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static String? localEmail;
  static String? localUid;

  User? get currentUser => _auth.currentUser;

  // Autenticação com e-mail e senha
  Future<UserCredential> loginWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Cadastro de novo usuário com e-mail e senha
  Future<UserCredential> registerWithEmail(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Encerramento da sessão
  Future<void> logout() async {
    localEmail = null;
    localUid = null;
    try {
      await _auth.signOut();
    } catch (_) {}
  }

  // Salva o registro de ponto do funcionário
  Future<void> savePontoRecord({
    required double latitude,
    required double longitude,
  }) async {
    final uid = currentUser?.uid ?? localUid ?? 'dev_user';
    final email = currentUser?.email ?? localEmail ?? 'dev@empresa.com';

    try {
      await _db.collection('registros_ponto').add({
        'employeeId': uid,
        'employeeEmail': email,
        'timestamp': FieldValue.serverTimestamp(),
        'location': GeoPoint(latitude, longitude),
      });
    } catch (_) {
      // Ignora erro caso esteja rodando offline ou sem chave válida
    }
  }

  // Stream dos registros do funcionário em tempo real
  Stream<QuerySnapshot> getEmployeeRecords() {
    final user = currentUser;
    if (user == null) return const Stream.empty();

    try {
      return _db
          .collection('registros_ponto')
          .where('employeeId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .snapshots();
    } catch (_) {
      return const Stream.empty();
    }
  }
}