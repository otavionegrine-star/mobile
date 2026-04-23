import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller/tarefa_controller.dart';
import 'view/tarefa_view.dart';

void main(List<String> args) {
  runApp(ChangeNotifierProvider(
    create: (context) => TarefaController(),
    child: MaterialApp(
      home: TarefaView(),
    ),
  ));
}