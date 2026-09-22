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

  Future<void> _carregarCheckIns() async {
    setState(() => _isLoading = true);
    final dados = await DBHelper.getCheckIns();
    setState(() {
      _checkIns = dados;
      _isLoading = false;
    });
  }

  Future<void> _abrirMapa(double lat, double lng) async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o mapa.')),
        );
      }
    }
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
              ? const Center(
                  child: Text(
                    'Nenhum ponto ou visita registrada.\nClique no botão + para adicionar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _checkIns.length,
                  itemBuilder: (context, index) {
                    final item = _checkIns[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: File(item.caminhoFoto).existsSync()
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
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.observacao),
                            const SizedBox(height: 4),
                            Text(
                              'Lat: ${item.latitude.toStringAsFixed(4)}, Lng: ${item.longitude.toStringAsFixed(4)}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.map, color: Colors.blue),
                          onPressed: () => _abrirMapa(item.latitude, item.longitude),
                          tooltip: 'Abrir no Mapa',
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CheckInFormScreen()),
          );
          if (result == true) {
            _carregarCheckIns();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}