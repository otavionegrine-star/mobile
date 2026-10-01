import 'package:geolocator/geolocator.dart';

class LocationService {
  // Exemplo: Local de trabalho padrão (Latitude, Longitude)
  // Altere para a coordenada real do local de trabalho
  static const double targetLatitude = -23.550520;
  static const double targetLongitude = -46.633309;
  static const double maxDistanceMeters = 100.0;

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception(
        'Serviço de GPS desativado. Por favor, ative a localização no dispositivo.',
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização negada pelo usuário.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Permissão de localização negada permanentemente nas configurações.',
      );
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  bool isWithinAllowedRadius(double currentLat, double currentLng) {
    // Distância em metros utilizando a Fórmula de Haversine embutida no geolocator
    double distanceInMeters = Geolocator.distanceBetween(
      currentLat,
      currentLng,
      targetLatitude,
      targetLongitude,
    );

    return distanceInMeters <= maxDistanceMeters;
  }

  double calculateDistance(double currentLat, double currentLng) {
    return Geolocator.distanceBetween(
      currentLat,
      currentLng,
      targetLatitude,
      targetLongitude,
    );
  }
}
