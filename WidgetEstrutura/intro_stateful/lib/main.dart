import '../../intro_exibicao/lib/main.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    home: MyApp()
  ));
}

// importando as caracteristicas da página StateFul
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // método para indentificar as mudanças de estado e chamar a reconstrução da janela
  @override //reescrita de um método existente
  State<MyApp> createState() => _MyAppState();
  //arrow Fucntion
}

//class para construção da lógica e da estrutura da janela
class _MyAppState extends State<MyApp>{
  //a classe normal da aplicação
  //atributos
  int contador = 0;

  //método build da tela (método Obrigatório)
  @override
  Widget build(BuildContext context){
    return Scaffold(
      //appbar - titulo do app
      appBar: AppBar(title:Text("Aplicativo comStateful - Contador")),
      //body
      //container para espaçamento interno
      body: Padding(
        padding: EdgeInsets.all(8), //espaçamento de 8 em todas as bordas
        //constaner para Centralizar os Elemetnos no meio da Tela (Esquerda e Direita)
        child: Center(//|->e<-|
          //Column => permite adicionar mais de um elemento
          child: Column(
            // Centraliza os elemento no Eixo Principal da Column (Y)
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Nº de Click: $contador", style: TextStyle(fontSize: 20)),
              // adicioanr um botão => toda vez que for pressionado  vai criar uma ação ( uma mudança de Estado)
              ElevatedButton(
                onPressed: (){
                  //adicionar setState (Mudança de Estado)
                  setState((){
                    //colocar uma modificação na tela
                    contador++; //adiciona 1 ao contador
                  });
                },
                child: Text("Adicionar +1")
              )
            ]
          )
        )
      )
    );
  }

}


