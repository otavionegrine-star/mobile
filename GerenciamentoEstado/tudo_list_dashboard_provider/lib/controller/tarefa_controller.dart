//controller vai ter a função de provider

import 'package:flutter/material.dart';
import '../model/tarefa.dart';

class TarefaController extends ChangeNotifier{
  // tranformo a classe controller em herdeira da changeNotifier (Provider)
  //classe que vai armazenar tarefas
  List<Tarefa> _tarefas = []; //array que vai aramazenar as tarefas criadas ( obj da classe model)
  // obs: _ => atributo privado

  //Liberar o Acesso (getter)
  List<Tarefa> get tarefas => _tarefas;

// métodos (CRUD)
  //CREATE
  void createTarefa(String titulo){
    
    if(titulo.trim().isEmpty)return;// se o titulo estiver vazio, interrompe o métodos

    _tarefas.add(Tarefa(titulo: titulo)); //adicionar um obj de Tarefa ao Vetor

    notifyListeners(); // avisar ao listeners que foi adicionado uma tarefa no vetor

  }

  //UPDATE
  void updateTarefa(int index){
    _tarefas[index].concluida = !_tarefas[index].concluida;
    // "!" inverte o valor da booleana
    notifyListeners();
  }

  //DELETE
  void deleteTarefa(int index){
    _tarefas.removeAt(index);
    notifyListeners();
  }

   //Criar métodos para definição das métricas
  // TotalTarefas => calcula no nº total de Tarefas
  int get totalTarefas => _tarefas.length;

  //TotalTarefasConcluidas
  int get totalTarefasConcluidas => _tarefas.where((tarefa)=>tarefa.concluida).length;

  //TotalTarefasPendentes
  int get totalTarefasPendentes => _tarefas.where((tarefa)=>!tarefa.concluida).length;

  //porcentagemTarefasConcluidas
  double get porcentagemTarefasConcluidas {
    if(totalTarefas==0) return 0;
    return totalTarefasConcluidas/totalTarefas*100;
  }


  }