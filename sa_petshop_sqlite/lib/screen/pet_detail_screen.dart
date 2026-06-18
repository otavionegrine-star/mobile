import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sa_petshop_sqlite/database/database_helper.dart';
import 'package:sa_petshop_sqlite/model/consulta_model.dart';
import 'package:sa_petshop_sqlite/model/pet_model.dart';

class PetDetailScreen extends StatefulWidget {
  final Pet pet;// sera importado da tela anterior o obj PET
  const PetDetailScreen({super.key, required this.pet});

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Perfil: ${widget.pet.nome}")),
      body: Column(
        children: [
          ListTile(title: Text("Dono: ${widget.pet.nomeDono}"), subtitle: Text("Tel: ${widget.pet.telefone}")),
          Divider(),
          Padding(padding: EdgeInsets.all(8), child: Text("Histórico de Consultas", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
            //lista com os serviços deste pet
            child: FutureBuilder<List<Consulta>>(
              future: DatabaseHelper().getConsultasPorPet(widget.pet.id!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                final consultas = snapshot.data!;
                return ListView.builder(
                  itemCount: consultas.length,
                  itemBuilder: (context, i) => Card(
                    child: ListTile(
                      title: Text(consultas[i].tipoServico),
                      subtitle: Text(consultas[i].dataHora),
                      trailing: Icon(Icons.calendar_today),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      //botão para criar novo serviço para  pet
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Agendar"),
        icon: Icon(Icons.add_task),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => AddConsultaScreen(pet: widget.pet))).then((value) => setState(() {})),
      ),
    );;
  }
}