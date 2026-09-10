import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  // ATENÇÃO: Substitua pelo seu token/API Key do OpenWeatherMap
  static const String _apiKey = '9f8a4a50c7c68a16e3fb2bc7bf24a5ac';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  static Future<Weather> fetchWeather(double lat, double lon) async {
    final url = Uri.parse(
      '$_baseUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=pt_br',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Weather.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Chave de API inválida ou ainda não ativada.');
      } else {
        throw Exception('Falha ao obter dados do clima (${response.statusCode}).');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Não foi possível conectar ao serviço de clima.');
    }
  }
}