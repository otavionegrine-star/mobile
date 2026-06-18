import 'package:sa_petshop_sqlite/database/database_helper.dart';
import 'package:sa_petshop_sqlite/model/consulta_model.dart';
import 'package:sa_petshop_sqlite/model/pet_model.dart';

class ConsultaController {
  final _dbHelper = DatabaseHelper();

  Future<bool> salvaConsulta(Consulta c) async{
    await _dbHelper.insertConsulta(c);
    return true;
  }

  Future<List<Consulta>> listarConsultas(int petId) async => await _dbHelper.getConsultasPorPet(petId);
}