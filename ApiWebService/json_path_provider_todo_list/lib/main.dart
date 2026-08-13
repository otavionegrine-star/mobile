import 'package:flutter/material.dart';
import 'package:json_path_provider_todo_list/usuarios_page.dart';

void main(List<String> args) {
  //WidgetFlutterBinding => Garente que os bindings do flutter esteja inicializados
  //inicializa os pacotes nativos do flutter logo no começo da aplicação
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: "Gerenciador de Tarefas com JSON" ,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.pink,
      //Tema padrão
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
        elevation: 2, //
      ),
    ),
    home: UsuariosPage(),
  ));
}