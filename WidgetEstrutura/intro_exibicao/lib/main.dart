// tela para estudo dos widgets de exibição
//  text, image, icon entre outros

import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      //configurações iniciais do App
      //router => rotas de navegação
      //home => pagina Inicial
      home: MyApp(),
      //themeApp => (Claro/Escuro)
    ),
  ); //gosto de colocar o MaterialApp no void main
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // estrutura da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //elemento principal da tela
      //appbar, drawer, bnBar, body, fabutton, snakebar
      appBar: AppBar(title: Text("Exemplos de Widget de Exibição")),

      //adicionar um elemento de Scroll
      
      body: Padding(
        padding: EdgeInsets.all(16),
        //Widget de Text
        //adicionar um container

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Explorando o Flutter",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            //dentro da column
            //adicionar uma image
            Image.network(
              //Link URL daImagem
              "https://images.unsplash.com/photo-1531259683007-016a7b628fc3",
              height: 600,
              fit: BoxFit.contain,),
            //adicionar imagem local
            Image.asset("assets/images/cachorrinho dos desejos.jpg",
              height: 250,
              fit: BoxFit.cover,)

          ],
        ),
      ),

    );
  }
}

