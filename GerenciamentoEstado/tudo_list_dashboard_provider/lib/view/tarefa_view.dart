import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/tarefa_controller.dart';
import 'dashboard_view.dart';

class TarefaView extends StatefulWidget {
  const TarefaView({super.key});

  @override
  State<TarefaView> createState() => _TarefaViewState();
}

class _TarefaViewState extends State<TarefaView> {
  //controlador do Input
  final TextEditingController _tarefaInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //controller das funções do crud para operar no build
    final tarefaController = Provider.of<TarefaController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Gerenciador de Tarefas"), 
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>DashboardView()));
            }, 
            icon: Icon(Icons.arrow_circle_right))
        ],),
      body: Padding(padding: EdgeInsets.all(8), child: Column(
        children: [
          //input do texto da tarefa
          TextField(
            controller: _tarefaInput,
            decoration: InputDecoration(
              //placeholder
              labelText: "Digite a Tarefa...",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffix: IconButton(
                onPressed: (){
                  //ao pressionar o botão + adiciona a tarefa no vetor
                  tarefaController.createTarefa(_tarefaInput.text);
                  // limpa o campo do input
                  _tarefaInput.clear();
                }, 
                icon: Icon(Icons.add),color: Colors.green,)
            ),
          ),
          //lista com as tarefas
          //expanded permite o scrol de parte da tela
          Expanded(
            child: tarefaController.tarefas.isEmpty 
            ? Center(child: Text("Nenhuma Tarefa Foi Adicionada"),)
            : ListView.builder(
              itemCount: tarefaController.tarefas.length,
              itemBuilder: (context, index){
                //sera construido algo para cara elemento da lista (ForEach)
                final tarefa = tarefaController.tarefas[index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.all(6),
                  child: ListTile(
                    leading: Checkbox(
                      value: tarefa.concluida, 
                      //o value não importa, o que importa e a execução do método, é o método que vai inverter o valor da tarefa
                      onChanged: (_)=>tarefaController.updateTarefa(index)),
                    title: Text(tarefa.titulo,style: TextStyle(
                      decoration: tarefa.concluida ? TextDecoration.lineThrough : TextDecoration.none),),
                    subtitle: Text(tarefa.concluida ? "Concluída" : "Pendente"),
                    trailing: IconButton(
                      onPressed: ()=> tarefaController.deleteTarefa(index), 
                      icon: Icon(Icons.delete, color: Colors.red,)),
                  ),
                  
                );
              }) 
            )
        ],
      ),),
    );
  }
}