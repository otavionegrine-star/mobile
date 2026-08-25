import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/produto.dart';
// Classe responsável por gerenciar o armazenamento dos produtos em um arquivo JSON

class ProdutoStorage {
  // Retorna a referência do arquivo no diretório de documentos do app
  Future<File> _getArquivo() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/produtos.json');
  }

  // Lê o JSON e converte para uma lista de produtos
  Future<List<Produto>> carregarProdutos() async {
    try {
      final arquivo = await _getArquivo();
      if (!await arquivo.exists()) return [];

      final conteudo = await arquivo.readAsString();
      if (conteudo.isEmpty) return [];

      final List jsonList = jsonDecode(conteudo);
      return jsonList.map((item) => Produto.fromJson(Map<String, dynamic>.from(item))).toList();
    } catch (e) {
      return [];
    }
  }

  // Grava a lista atualizada de produtos no arquivo JSON
  Future<void> salvarProdutos(List<Produto> produtos) async {
    try {
      final arquivo = await _getArquivo();
      final jsonList = produtos.map((p) => p.toJson()).toList();
      await arquivo.writeAsString(jsonEncode(jsonList));
    } catch (e) {
      // Tratar ou registrar erros de escrita se necessário
    }
  }
}