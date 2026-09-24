import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // Solicita permissão e abre a câmera nativa
  Future<void> _capturarFoto() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      _mostrarSnackBar('Permissão de câmera negada.');
      return;
    }
    final picker = ImagePicker();
    final photo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (photo != null) {
      setState(() => _caminhoFoto = photo.path);
    }
  }

  // Verifica permissão e disponibilidade do serviço de localização
  Future<bool> _validarPermissaoLocalizacao() async {
    final status = await Permission.location.request();
    if (!status.isGranted) {
      _mostrarSnackBar('Permissão de localização negada.');
      return false;
    }
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _mostrarSnackBar('Por favor, ative o GPS do dispositivo.');
      return false;
    }
    return true;
  }

  // Obtém a posição atual do GPS com alta precisão
  Future<void> _obterLocalizacao() async {
    setState(() => _obtendoLocalizacao = true);
    if (await _validarPermissaoLocalizacao()) {
      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );
        setState(() => _posicaoAtual = position);
      } catch (e) {
        _mostrarSnackBar('Erro ao capturar localização.');
      }
    }
    setState(() => _obtendoLocalizacao = false);
  }

  // Valida os dados antes de prosseguir com o salvamento
  bool _validarDadosFormulario() {
    if (!_formKey.currentState!.validate()) return false;
    if (_caminhoFoto == null) {
      _mostrarSnackBar('Por favor, tire uma foto antes de salvar.');
      return false;
    }
    if (_posicaoAtual == null) {
      _mostrarSnackBar('Por favor, obtenha a localização GPS antes de salvar.');
      return false;
    }
    return true;
  }

  // Executa o salvamento no banco SQLite
  Future<void> _persistirRegistro() async {
    final novoCheckIn = CheckIn(
      dataHora: DateTime.now().toString().substring(0, 19),
      latitude: _posicaoAtual!.latitude,
      longitude: _posicaoAtual!.longitude,
      observacao: _obsController.text.trim(),
      caminhoFoto: _caminhoFoto!,
    );
    await DBHelper.insertCheckIn(novoCheckIn);
  }

  // Emite feedback sonoro ao salvar com sucesso
  Future<void> _emitirFeedbackSonoro() async {
    try {
      await SystemSound.play(SystemSoundType.click);
      await _audioPlayer.play(AssetSource('sounds/success.mp3'));
    } catch (_) {
      // Ignora erro caso o dispositivo silencie ou bloqueie áudio
    }
  }

  // Fluxo principal para salvar o registro
  Future<void> _salvarRegistro() async {
    if (!_validarDadosFormulario()) return;

    setState(() => _salvando = true);
    await _persistirRegistro();
    await _emitirFeedbackSonoro();

    if (mounted) {
      _mostrarSnackBar('Registro salvo com sucesso!');
      Navigator.pop(context, true);
    }
  }

  // Exibe mensagens em SnackBar
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

  // Constrói o container de exibição e captura da foto
  Widget _buildAreaFoto() {
    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: _caminhoFoto != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(File(_caminhoFoto!), fit: BoxFit.cover),
                )
              : const Center(child: Text('Nenhuma foto capturada')),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _capturarFoto,
          icon: const Icon(Icons.camera_alt),
          label: const Text('Tirar Foto'),
        ),
      ],
    );
  }

  // Constrói o card com informações e botão de localização GPS
  Widget _buildAreaGPS() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            if (_obtendoLocalizacao)
              const CircularProgressIndicator()
            else
              Text(
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
    );
  }

  // Constrói o campo de texto para observação
  Widget _buildCampoObservacao() {
    return TextFormField(
      controller: _obsController,
      decoration: const InputDecoration(
        labelText: 'Observação / Descrição da Visita',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
      validator: (val) {
        return (val == null || val.trim().isEmpty)
            ? 'Informe uma observação'
            : null;
      },
    );
  }

  // Constrói o botão de confirmação e salvamento
  Widget _buildBotaoSalvar() {
    return ElevatedButton(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Registro de Ponto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAreaFoto(),
              const SizedBox(height: 20),
              _buildAreaGPS(),
              const SizedBox(height: 20),
              _buildCampoObservacao(),
              const SizedBox(height: 24),
              _buildBotaoSalvar(),
            ],
          ),
        ),
      ),
    );
  }
}