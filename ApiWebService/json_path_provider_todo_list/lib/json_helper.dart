//lógica de persistência de Dados

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
//importar o path_provider

class JsonHelper {
  // métodos static => médotos da Classe e não do OBJ ( para usar o método não precisa instanciar OBJ)
  // 1. método Obter Arquivo Json (static)
  static Future<File> _getArquivo() async{
    final diretorio = await getApplicationDocumentsDirectory(); // buscando os arquivos do aplicativo
    return File("${diretorio.path}/bd.json"); // retorna o caminho do arquivo json
    //se arquivo não existir, ele será criado automaticamente
  }

  //2. Ler todos os Dados do Json (Converter Json em Map)
  static Future<Map<String, dynamic>> lerDados() async{
    try {
      final arquivo = await _getArquivo();//busco o arquivo
      //verifico se o arquivo existe
      if(await arquivo.exists()){
        String conteudo = await arquivo.readAsString();
        return json.decode(conteudo);
      }
    } catch (e) {
      print("Erro ao ler o arquivo: $e");
    }
    return {}; //Retorna um Map vazio se não existir ou der erro
  }


  //3. Salvar os Dados no Arquivo Json
  static Future<void> salvarDados(Map<String,dynamic> dados) async{
    try {
      final arquivo = await _getArquivo();// pegando o logal do arquivo
      String jsonString = json.encode(dados);// transdormando MAP em Json
      await arquivo.writeAsString(jsonString); // armazenando os dados no local 
    } catch (e) {
      print("Erro ao salvar o arquivo: $e");
    }
  }
}