import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class TmdbService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = '0f267c5b9987bccd560671d5dee40475'; //

  static Future<List<Movie>> searchMovies(String query) async {
    if (query.trim().isEmpty) return [];

    final url = Uri.parse(
      '$_baseUrl/search/multi?api_key=$_apiKey&language=pt-BR&query=${Uri.encodeComponent(query)}',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        return results
          .where((json) => json['media_type'] == 'movie' || json['media_type'] == 'tv')
          .map((json) => Movie.fromJson(json))
          .toList();
      } else {
        throw Exception('Falha ao carregar filmes');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}