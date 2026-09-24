import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database/db_helper.dart';
import '../models/checkin_model.dart';
import 'checkin_form_screen.dart';

class CheckInListScreen extends StatefulWidget {
  const CheckInListScreen({super.key});

  @override
  State<CheckInListScreen> createState() => _CheckInListScreenState();
}

class _CheckInListScreenState extends State<CheckInListScreen> {
  List<CheckIn> _checkIns = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarCheckIns();
  }

  // Carrega os registros salvos do banco SQLite
  Future<void> _carregarCheckIns() async {
    setState(() => _isLoading = true);
    final dados = await DBHelper.getCheckIns();
    setState(() {
      _checkIns = dados;
      _isLoading = false;
    });
  }

  // Abre as coordenadas geográficas no aplicativo de mapas
  Future<void> _abrirMapa(double lat, double lng) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o mapa.')),
      );
    }
  }

  // Remove o registro do banco de dados e recarrega a lista
  Future<void> _excluirRegistro(int id) async {
    await DBHelper.deleteCheckIn(id);
    await _carregarCheckIns();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro excluído com sucesso!')),
      );
    }
  }

  // Confirma a exclusão de um registro com o usuário
  Future<void> _confirmarExclusao(int id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Registro'),
        content: const Text('Deseja realmente excluir este registro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmar == true) await _excluirRegistro(id);
  }

  // Navega até a tela de cadastro de ponto
  Future<void> _abrirFormulario() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CheckInFormScreen()),
    );
    if (result == true) {
      await _carregarCheckIns();
    }
  }

  // Exibe modal com detalhes completos do registro
  void _exibirDetalhes(CheckIn item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _buildDetalhesConteudo(ctx, item),
    );
  }

  // Constrói os botões de ação na visualização de detalhes
  Widget _buildAcoesDetalhes(BuildContext ctx, CheckIn item) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.map),
            label: const Text('Abrir no Mapa'),
            onPressed: () => _abrirMapa(item.latitude, item.longitude),
          ),
        ),
        if (item.id != null) ...[
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              _confirmarExclusao(item.id!);
            },
          ),
        ],
      ],
    );
  }

  // Constrói o conteúdo exibido no modal de detalhes
  Widget _buildDetalhesConteudo(BuildContext ctx, CheckIn item) {
    final existeFoto = File(item.caminhoFoto).existsSync();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(item.dataHora, style: Theme.of(ctx).textTheme.titleLarge),
          const SizedBox(height: 12),
          if (existeFoto)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(item.caminhoFoto),
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 12),
          Text('Observação: ${item.observacao}'),
          const SizedBox(height: 4),
          Text('Coordenadas: ${item.latitude}, ${item.longitude}'),
          const SizedBox(height: 16),
          _buildAcoesDetalhes(ctx, item),
        ],
      ),
    );
  }

  // Constrói o card de cada registro na listagem
  Widget _buildItemTile(CheckIn item) {
    final existeFoto = File(item.caminhoFoto).existsSync();
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        onTap: () => _exibirDetalhes(item),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: existeFoto
              ? Image.file(
                  File(item.caminhoFoto),
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.image_not_supported, size: 50),
        ),
        title: Text(
          item.dataHora,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          item.observacao,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.map, color: Colors.blue),
          onPressed: () => _abrirMapa(item.latitude, item.longitude),
        ),
      ),
    );
  }

  // Constrói o estado vazio da lista
  Widget _buildEstadoVazio() {
    return const Center(
      child: Text(
        'Nenhum ponto ou visita registrada.\nClique no botão + para adicionar.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SENAI CheckIn — Diário'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _checkIns.isEmpty
              ? _buildEstadoVazio()
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _checkIns.length,
                  itemBuilder: (context, index) =>
                      _buildItemTile(_checkIns[index]),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirFormulario,
        child: const Icon(Icons.add),
      ),
    );
  }
}