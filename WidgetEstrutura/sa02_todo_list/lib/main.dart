// situação de aprendizagem 02 -  aplicativo todo-list

import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: TodoListView()));
}

// a classe da Janela Stateful
// 1º classe: identifica ass mudanças de estado e chama o rebuild da tela
class TodoListView extends StatefulWidget {
  const TodoListView({super.key});

  //chama o rebuild
  @override
  State<TodoListView> createState() => _TodoListViewState(); //arrow function

  // State<TodoListView> createState(){
  //   return _TodoListViewState();
  // }
}

// 2º classe: fica a lógica da tela, atributos / métodos
class _TodoListViewState extends State<TodoListView> {
  // atributos
  //obj para controlar os dados do input
  //final => permite a mudança de valor uma unica vez
  // _ o uso do underline, transforma a variuável em private
  final TextEditingController _tarefasController =
      TextEditingController(); //pegar p valor do input
  final List<Map<String, dynamic>> _tarefas =
      []; //Lista de Coleçoes [{},{},{}], Cada Coleção é um MAP (Key,value)

  //métodos

  //build => lógica ´por trás da Janela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Tarefas"), centerTitle: true),
      body: Padding(
        //espaçamento geral de 8px
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            //adicionar + de 1 Elemento
            //input da tarefa
            TextField(
              //controle para o texto inserido
              controller:
                  _tarefasController, // passar o valor do texto para o controller
              decoration: InputDecoration(
                //placeholder do input
                labelText: "Digite uma Tarefa...",
              ),
            ),
            //espaçamento
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _adicionarTarefa, // método para adicionar Tarefa a Lista
              child: Text("Adicionar Tarefa"),
            ),
            //listar as tarefas da lista
            //scroll de parte da tela
            Expanded(
              child: ListView.builder(
                itemCount:
                    _tarefas.length, //contagem de quantas tarefas vão ter
                itemBuilder: (context, index) =>
                    //para cada elemento faça FOREACH
                    ListTile(
                      title: Text(
                        _tarefas[index]["titulo"],
                        style: TextStyle(
                          // operador ternário
                          decoration: _tarefas[index]["concluida"]
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      //adicionar um checkbox antes do texto
                      leading: Checkbox(
                        value: _tarefas[index]["concluida"],
                        onChanged: (bool? valor) => setState(() {
                          //rebuild da janela
                          _tarefas[index]["concluida"] =
                              valor!; //invrete o valor da booleana
                        }),
                      ),
                      //adicionar icone par deletar ttarefa (IconButton // Elevate)
                      trailing: IconButton(
                        onPressed: () => _deletarTarefa(index),
                        icon: Icon(Icons.delete),
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //método para adicionar tarefa
  void _adicionarTarefa() {
    //TODO: create Tarefa
    if (_tarefasController.text.trim().isNotEmpty) {
      // se tarefa nãp estiver vazia
      //adiciona a tarefa a lista
      //mudar o estado da janela
      setState(() {
        // envia um aviso da mudança de estado
        _tarefas.add({
          "titulo": _tarefasController.text.trim(),
          "concluida": false,
        });
      });
    }
  }

  //método para deletar tarefa
  void _deletarTarefa(int index) {
    //TODO: delete Tarefa
    if (_tarefas[index]["concluida"] == true) {
      setState(() {
        _tarefas.remove(_tarefas[index]);
      });
    }
  }
}
