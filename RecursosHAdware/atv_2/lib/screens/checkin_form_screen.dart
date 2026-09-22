import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import '../database/db_helper.dart';
import '../models/checkin_model.dart';

class CheckInFormScreen extends StatefulWidget {
  const CheckInFormScreen({super.key});

  @override
  State<CheckInFormScreen> createState() => _CheckInFormScreenState();
}

class _CheckInFormScreenState extends State<CheckInFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _obsController = TextEditingController();

  String? _caminhoFoto;
  Position? _posicaoAtual;
  bool _obtendoLocalizacao = false;
  bool _salvando = false;

  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _capturarFoto() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final picker = ImagePicker();
      final photo = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
      if (photo != null) {
        setState(() {
          _caminhoFoto = photo.path;
        });
      }
    } else {
      _mostrarSnackBar('Permissão de câmera negada.');
    }
  }

  Future<void> _obterLocalizacao() async {
    setState(() => _obtendoLocalizacao = true);
    var status = await Permission.location.request();

    if (status.isGranted) {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _mostrarSnackBar('Por favor, ative o GPS do dispositivo.');
        setState(() => _obtendoLocalizacao = false);
        return;
      }

      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          _posicaoAtual = position;
        });
      } catch (e) {
        _mostrarSnackBar('Erro ao capturar localização.');
      }
    } else {
      _mostrarSnackBar('Permissão de localização negada.');
    }
    setState(() => _obtendoLocalizacao = false);
  }

  Future<void> _salvarRegistro() async {
    if (!_formKey.currentState!.validate()) return;

    if (_caminhoFoto == null) {
      _mostrarSnackBar('Por favor, tire uma foto antes de salvar.');
      return;
    }

    if (_posicaoAtual == null) {
      _mostrarSnackBar('Por favor, obtenha a localização GPS antes de salvar.');
      return;
    }

    setState(() => _salvando = true);

    final novoCheckIn = CheckIn(
      dataHora: DateTime.now().toString().substring(0, 19),
      latitude: _posicaoAtual!.latitude,
      longitude: _posicaoAtual!.longitude,
      observacao: _obsController.text,
      caminhoFoto: _caminhoFoto!,
    );

    await DBHelper.insertCheckIn(novoCheckIn);

    // Feedback Sonoro
    try {
      await _audioPlayer.play(AssetSource('sounds/success.mp3'));
    } catch (_) {
      // Ignora erro caso o arquivo de som não esteja configurado
    }

    if (mounted) {
      _mostrarSnackBar('Registro salvo com sucesso!');
      Navigator.pop(context, true);
    }
  }

  void _mostrarSnackBar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  void dispose() {
    _obsController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Registro de Ponto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Área da Foto
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: _caminhoFoto != null
                    ? Image.file(File(_caminhoFoto!), fit: BoxFit.cover)
                    : const Center(
                        child: Text('Nenhuma foto capturada'),
                      ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _capturarFoto,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Tirar Foto'),
              ),
              const SizedBox(height: 20),

              // Área da Localização GPS
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      _obtendoLocalizacao
                          ? const CircularProgressIndicator()
                          : Text(
                              _posicaoAtual != null
                                  ? 'Lat: ${_posicaoAtual!.latitude}\nLng: ${_posicaoAtual!.longitude}'
                                  : 'Localização ainda não capturada',
                              textAlign: TextAlign.center,
                            ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: _obterLocalizacao,
                        icon: const Icon(Icons.my_location),
                        label: const Text('Obter Localização GPS'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Campo de Observação
              TextFormField(
                controller: _obsController,
                decoration: const InputDecoration(
                  labelText: 'Observação / Descrição da Visita',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe uma observação';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Botão de Salvar
              ElevatedButton(
                onPressed: _salvando ? null : _salvarRegistro,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: _salvando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'SALVAR REGISTRO',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}