// uso do Shared Preferences para Armazenar o Nome do Usuário

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Exemplo1Page extends StatefulWidget {
  const Exemplo1Page({super.key});

  @override
  State<Exemplo1Page> createState() => _Exemplo1PageState();
}

class _Exemplo1PageState extends State<Exemplo1Page> {
  TextEditingController _nomeInput = TextEditingController();
  String _nomeSalvo = "";
  SharedPreferences? _prefs;
  bool _darkMode = false;

  //uso shared ´para buscar o nome no inicio do aplicativo 
  //salvar nome nas preferencias
  _salvarNomeShared() async{ // conexão async => permite continuar rodadno o código enquanto é feito a conexão com a base de dados
  //conectar com o SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();// busca as informaç~eos salvas no shared prefs
  await prefs.setString("nome",_nomeInput.text.trim()); // salvou na chave "nome" => o valor colocado no input
  _nomeInput.clear();
  _carregarNomeShared(); // atualiza o nome para a tela
  }

  //buscar nome nas preferencias
  _carregarNomeShared() async{
    SharedPreferences prefs = await 
    SharedPreferences.getInstance();
    //atualiza o estado da pagina
    setState(() {
      //atribuindo a variavel o valor relacionada a chave busca do shared
      _nomeSalvo = prefs.getString("nome") ?? "" ; //operador de nulidade
    });
  }

  void _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = _prefs!.getBool("darkMode") ?? false;
    });
  }

  void _savePreferences() async {
    setState(() {
      _darkMode = !_darkMode;
    });
    await _prefs?.setBool("darkMode", _darkMode);
  }

  //inicio da página
  @override
  //método que é iniciado, antes mesp, do build, para carregar as informações do SharedPreferences antes de buildar a tela pela 1º vez
  void initState() { // carrega informações do SharedPreferences antes de buildar a tela pela 1º vez
    super.initState();
    _carregarNomeShared();
    _loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(brightness: _darkMode ? Brightness.dark : Brightness.light),
      child: Scaffold(
        appBar: AppBar(title: Text("Bem Vindo $_nomeSalvo"), centerTitle: true,),
        body: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nomeInput,
                decoration: InputDecoration(labelText: "Digite seu nome..."),
              ),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: _salvarNomeShared, child: Text("Salvar")),
              SizedBox(height: 10,),
              Text("O Nome do Usuário Atual é $_nomeSalvo", style: TextStyle(fontSize: 20)),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Modo Escuro"),
                  Switch(value: _darkMode, onChanged: (_) => _savePreferences()),
                ],
              ),
              SizedBox(height: 20,),
              TextButton(onPressed: () => Navigator.pop(context), child: Text("Voltar"))
            ],
          ),),
      ),
    );
  }
}
