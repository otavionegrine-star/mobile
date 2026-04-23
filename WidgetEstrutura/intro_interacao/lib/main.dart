//Uso de Elementos de Interação ( TextField, ElevatedButton, CheckBox, Slider)

import 'package:flutter/material.dart';

import 'pages/contato_page.dart';
import 'pages/form_page.dart';
import 'pages/home_page.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    //sistema de rotas para navegação entre telas
    //home(Tela Inicial), Form: (tela com Formulário), Contato(Formulário de Contato)
    routes: {
      "/":(context) => HomePage(),
      "/form":(context) => FormPage(),
      "/contato":(context) => ContatoPage(),
    },
    //direcionar o aplicativo quando iniciar para a home
    initialRoute: "/",

  ));
}

// página main finalizada