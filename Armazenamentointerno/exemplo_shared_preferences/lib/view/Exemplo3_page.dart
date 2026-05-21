import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Exemplo3Page extends StatefulWidget {
  const Exemplo3Page({super.key});

  @override
  State<Exemplo3Page> createState() => _Exemplo3PageState();
}

class _Exemplo3PageState extends State<Exemplo3Page> {
  SharedPreferences? _prefs;
  String nome = "";
  List<String> _tarefas = [];
  final TextEditingController _inputTarefa = TextEditingController();

  // métodos
 @override
void initState() {
  // TODO: implement initState
  super.initState();
  _loadTarefas();
}

//carregar dados do Shared
Future<void> _loadTarefas() async {
  //conectar o App ao Shared
  _prefs = await SharedPreferences.getInstance();
  nome = _prefs!.getString("nome") ?? "";
  setState(() {
    _tarefas = _prefs!.getStringList("tarefas+$nome") ?? [];
  });
}

//salvar dados no Shared
void _savePreferences() async {
  _prefs = await SharedPreferences.getInstance();
  nome = _prefs!.getString("nome") ?? "";
  //Salvar as Preferencias
  await _prefs!.setStringList("tarefas+$nome", _tarefas);
  setState(() {});
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Tarefas de $nome")),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              controller: _inputTarefa,
              decoration: InputDecoration(labelText: "Difite a tarefa"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_inputTarefa.text.trim().isNotEmpty) {
                  setState(() {
                    _tarefas.add(_inputTarefa.text.trim());
                    _inputTarefa.clear();
                  });
                  _savePreferences();
                }
              },
              child: Text("Adicionar")
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _tarefas.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_tarefas[index]),
                    onLongPress: () {
                      setState(() {
                        _tarefas.removeAt(index);
                      });
                      _savePreferences();
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}