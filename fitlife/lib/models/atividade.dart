import 'package:flutter/material.dart';

class Atividade {
  final String id;
  final String nome;
  final IconData icone; // Adicionado para a UI
  bool concluida;

  Atividade({
    required this.id,
    required this.nome,
    required this.icone,
    this.concluida = false,
  });
}