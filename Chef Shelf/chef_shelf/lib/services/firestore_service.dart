// Gerenciamento de receitas no Firestore com suporte a cache local
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';
import 'auth_service.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;
  final _auth = AuthService();
  static final List<Recipe> _cache = [];
  static final _cacheController = StreamController<List<Recipe>>.broadcast();

  // Retorna referência da coleção caso esteja conectado com Firebase
  CollectionReference<Map<String, dynamic>>? get _collection {
    final uid = _auth.currentUser?.uid;
    if (uid == null || uid.startsWith('local_')) return null;
    return _db.collection('users').doc(uid).collection('recipes');
  }

  // Observa receitas salvas pelo usuário
  Stream<List<Recipe>> watchRecipes() {
    final col = _collection;
    if (col != null) {
      return col.snapshots().map((s) => s.docs.map((d) => Recipe.fromMap(d.data(), d.id)).toList());
    }
    return Stream.value(List<Recipe>.from(_cache)).concatWith([_cacheController.stream]);
  }

  // Salva receita no Firestore e no cache
  Future<void> saveRecipe(Recipe recipe) async {
    _cache.removeWhere((r) => r.id == recipe.id);
    _cache.add(recipe);
    _cacheController.add(List.from(_cache));
    try {
      await _collection?.doc(recipe.id).set(recipe.toMap(), SetOptions(merge: true));
    } catch (_) {}
  }

  // Exclui receita salva
  Future<void> deleteRecipe(String id) async {
    _cache.removeWhere((r) => r.id == id);
    _cacheController.add(List.from(_cache));
    try {
      await _collection?.doc(id).delete();
    } catch (_) {}
  }

  // Verifica se uma receita está salva
  Future<bool> isSaved(String id) async {
    if (_cache.any((r) => r.id == id)) return true;
    try {
      final doc = await _collection?.doc(id).get();
      return doc?.exists ?? false;
    } catch (_) {
      return false;
    }
  }
}

// Extensão simples para combinar streams
extension _StreamConcat<T> on Stream<T> {
  Stream<T> concatWith(List<Stream<T>> others) async* {
    yield* this;
    for (final s in others) {
      yield* s;
    }
  }
}
