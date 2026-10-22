// Serviço para consultar receitas na TheMealDB API
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class RecipeApi {
  static const _base = 'https://www.themealdb.com/api/json/v1/1';

  // Busca receitas pelo termo digitado
  Future<List<Recipe>> search(String query) async {
    final uri = Uri.parse('$_base/search.php').replace(
      queryParameters: {'s': query},
    );
    final response = await http.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar receitas.');
    }
    final meals = (jsonDecode(response.body)['meals'] as List?) ?? [];
    return meals
        .map((m) => Recipe.fromMeal(Map<String, dynamic>.from(m)))
        .toList();
  }

  // Carrega sugestões iniciais de receitas
  Future<List<Recipe>> getSuggestions() async {
    return search('chicken');
  }

  // Obtém os detalhes completos de uma receita por ID
  Future<Recipe> details(String id) async {
    final uri = Uri.parse('$_base/lookup.php').replace(
      queryParameters: {'i': id},
    );
    final response = await http.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar receita.');
    }
    final meals = (jsonDecode(response.body)['meals'] as List?) ?? [];
    if (meals.isEmpty) throw Exception('Receita não encontrada.');
    return Recipe.fromMeal(Map<String, dynamic>.from(meals.first));
  }
}
