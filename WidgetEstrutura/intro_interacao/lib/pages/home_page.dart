//tela inicial
// vai ter botões de navegação para outras telas


import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meu Aplicativo Interativo"),),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          //centraliza elementos na horizontal
          child: Column(
            //alinhamento do eixo vertical
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo do aplicativo
              Image.network("https://thumbs.dreamstime.com/b/logotipo-cl%C3%A1ssico-do-batman-isolado-em-fundo-branco-dia-bolonha-it%C3%A1lia-de-setembro-404052715.jpg",
              width: 150,
              height: 150,),
              //bloco de espaçamento
              SizedBox(height: 20,),
              //botoes de navegação
              ElevatedButton(
                onPressed: ()=> Navigator.pushNamed(context, "/form"), 
                child: Text("Responder Formulário")),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: ()=>Navigator.pushNamed(context, "/contato"), 
                child: Text("Entre em Contato"))
            ],
          ),
        ),),
    );
  }
}