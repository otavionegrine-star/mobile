import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../services/firebase_service.dart';
import '../services/location_service.dart';

// Provedor para gerenciar o registro de ponto do funcionário
class PontoProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final LocationService _locationService = LocationService();

  bool _isLoading = false;
  String? _statusMessage;
  bool _isSuccess = false;

  bool get isLoading => _isLoading;
  String? get statusMessage => _statusMessage;
  bool get isSuccess => _isSuccess;
  Stream<QuerySnapshot> get recordsStream => _firebaseService.getEmployeeRecords();

  // Executa o fluxo de registro de ponto
  Future<void> registrarPonto([String? userId, String? userEmail]) async {
    _setLoading(true);
    try {
      final pos = await _locationService.getCurrentLocation();
      await _validateAndSavePonto(pos, userId, userEmail);
    } catch (e) {
      _handleError(e);
    } finally {
      _setLoading(false);
    }
  }

  // Valida a proximidade com o local de trabalho e grava o ponto
  Future<void> _validateAndSavePonto(Position pos, String? id, String? email) async {
    final within = _locationService.isWithinAllowedRadius(pos.latitude, pos.longitude);
    final dist = _locationService.calculateDistance(pos.latitude, pos.longitude);

    if (!within) {
      _isSuccess = false;
      _statusMessage = 'Registro recusado! Distância: ${dist.toStringAsFixed(1)}m. Máx: 100m.';
      return;
    }

    await _firebaseService.savePontoRecord(
      latitude: pos.latitude,
      longitude: pos.longitude,
      employeeId: id,
      employeeEmail: email,
    );
    _isSuccess = true;
    _statusMessage = 'Ponto registrado com sucesso!';
  }

  // Trata mensagens de erro
  void _handleError(Object error) {
    _isSuccess = false;
    _statusMessage = error.toString().replaceAll('Exception: ', '');
  }

  // Atualiza estado de carregamento
  void _setLoading(bool value) {
    _isLoading = value;
    if (value) {
      _statusMessage = null;
      _isSuccess = false;
    }
    notifyListeners();
  }
}
}