import 'package:flutter/material.dart';
import '../models/atividade.dart';

class AtividadeProvider with ChangeNotifier {
  final List<Atividade> _atividades = [
    Atividade(id: '1', nome: 'Caminhada', icone: Icons.directions_walk),
    Atividade(id: '2', nome: 'Corrida', icone: Icons.directions_run),
    Atividade(id: '3', nome: 'Musculação', icone: Icons.fitness_center),
    Atividade(id: '4', nome: 'Yoga', icone: Icons.self_improvement),
  ];

  List<Atividade> get pendentes => _atividades.where((a) => !a.concluida).toList();
  List<Atividade> get concluidas => _atividades.where((a) => a.concluida).toList();

  // Métricas para o Dashboard
  int get totalConcluidas => concluidas.length;
  double get progressoMeta => (_atividades.isEmpty) ? 0 : (concluidas.length / _atividades.length);

  void alternarStatus(String id) {
    final index = _atividades.indexWhere((a) => a.id == id);
    if (index != -1) {
      _atividades[index].concluida = !_atividades[index].concluida;
      notifyListeners(); //
    }
  }

  void resetarProgresso() {
    for (var a in _atividades) { a.concluida = false; }
    notifyListeners();
  }
}