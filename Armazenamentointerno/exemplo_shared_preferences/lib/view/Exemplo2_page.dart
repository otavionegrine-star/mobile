import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Exemplo2Page extends StatefulWidget {
  const Exemplo2Page({super.key});

  @override
  State<Exemplo2Page> createState() => _Exemplo2PageState();
}

class _Exemplo2PageState extends State<Exemplo2Page> {
 SharedPreferences? _prefs; //escopo late,permite criar uma variavel inicialmente nula e mudar o valor depóis,
 //pode ser udada uatas vezes for nascessária
  bool _darkMode = false;
  
  
  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
  _prefs = await SharedPreferences.getInstance(); //pega as informações salvas no Shared
  setState(() {
   _darkMode = _prefs!.getBool("darkMode") ?? false; 
   // verificação de nulidade obrigatória, ?? se caso a chave darkMode de Shored seja nula (não tenha valor atribuida ainda)
   //a variavel _darkMode é falso
  });
}

// método para salvar dados no Shared
void _savePreferences() async {
  setState(() {
    _darkMode = !_darkMode; //inverte o valor da booleava
  });
  await _prefs!.setBool("darkMode", _darkMode);
}

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(brightness: _darkMode ? Brightness.dark : Brightness.light),
      child: Scaffold(
        appBar: AppBar(title: Text("Modo Escuro com Shared Preferences")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Tema atual: ${_darkMode ? "Escuro" : "Claro"}"),
              Switch(value: _darkMode, onChanged: (_) => _savePreferences())
            ],
          ),
        ),
      ),
    );
  }
}