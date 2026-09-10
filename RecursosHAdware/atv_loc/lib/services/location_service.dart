import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Obtém a posição atual do dispositivo lidando com permissões e GPS
  static Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Checa se o serviço de localização/GPS está ativado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(
        'O serviço de localização (GPS) está desativado. Por favor, ative-o no seu dispositivo.',
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('A permissão de localização foi negada.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'As permissões de localização foram negadas permanentemente. Altere nas configurações do celular.',
      );
    }

    // Obtém a localização com boa precisão
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}