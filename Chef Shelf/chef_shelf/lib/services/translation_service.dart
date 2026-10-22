// Serviço inteligente para tradução gastronômica de receitas
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() => _instance;
  TranslationService._internal();

  static final Map<String, String> _cache = {};

  // Dicionário gastronômico instantâneo para termos comuns
  static const Map<String, String> _dictionary = {
    'chicken': 'frango',
    'beef': 'carne bovina',
    'pork': 'carne de porco',
    'pasta': 'massa',
    'dessert': 'sobremesa',
    'seafood': 'frutos do mar',
    'vegetarian': 'vegetariano',
    'starter': 'entrada',
    'side': 'acompanhamento',
    'soup': 'sopa',
    'lamb': 'cordeiro',
    'italian': 'italiana',
    'american': 'americana',
    'french': 'francesa',
    'brazilian': 'brasileira',
    'mexican': 'mexicana',
    'indian': 'indiana',
    'chinese': 'chinesa',
    'japanese': 'japonesa',
    'british': 'britânica',
    'easy': 'fácil',
    'medium': 'médio',
    'hard': 'difícil',
    'onion': 'cebola',
    'garlic': 'alho',
    'salt': 'sal',
    'pepper': 'pimenta',
    'olive oil': 'azeite de oliva',
    'butter': 'manteiga',
    'sugar': 'açúcar',
    'flour': 'farinha',
    'water': 'água',
    'milk': 'leite',
    'egg': 'ovo',
    'eggs': 'ovos',
    'cheese': 'queijo',
    'tomato': 'tomate',
    'tomatoes': 'tomates',
    'cup': 'xícara',
    'cups': 'xícaras',
    'tablespoon': 'colher de sopa',
    'tablespoons': 'colheres de sopa',
    'teaspoon': 'colher de chá',
    'teaspoons': 'colheres de chá',
  };

  // Substitui termos culinários conhecidos
  String _applyDictionary(String input) {
    String result = input;
    _dictionary.forEach((key, val) {
      final reg = RegExp('\\b$key\\b', caseSensitive: false);
      result = result.replaceAllMapped(reg, (m) {
        final match = m.group(0)!;
        if (match[0] == match[0].toUpperCase()) {
          return val[0].toUpperCase() + val.substring(1);
        }
        return val;
      });
    });
    return result;
  }

  // Traduz um trecho de texto via API pública com fallback local
  Future<String> translateText(String text) async {
    final clean = text.trim();
    if (clean.isEmpty) return clean;
    if (_cache.containsKey(clean)) return _cache[clean]!;

    final dictResult = _applyDictionary(clean);
    if (clean.split(' ').length <= 4) {
      _cache[clean] = dictResult;
      return dictResult;
    }

    try {
      final uri = Uri.parse('https://api.mymemory.translated.net/get')
          .replace(queryParameters: {'q': clean, 'langpair': 'en|pt'});
      final res = await http.get(uri).timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        final translated = json['responseData']?['translatedText'] as String?;
        if (translated != null && translated.isNotEmpty) {
          _cache[clean] = translated;
          return translated;
        }
      }
    } catch (_) {}

    _cache[clean] = dictResult;
    return dictResult;
  }

  // Traduz uma lista de ingredientes ou instruções
  Future<List<String>> _translateList(List<String> list) async {
    final results = <String>[];
    for (final item in list) {
      results.add(await translateText(item));
    }
    return results;
  }

  // Traduz um objeto Recipe completo para Português
  Future<Recipe> translateRecipe(Recipe recipe) async {
    final translatedName = await translateText(recipe.name);
    final translatedCategory = _dictionary[recipe.category.toLowerCase()] ?? recipe.category;
    final translatedArea = _dictionary[recipe.area.toLowerCase()] ?? recipe.area;
    final translatedIngredients = await _translateList(recipe.ingredients);
    final translatedInstructions = await _translateList(recipe.instructions);

    return Recipe(
      id: recipe.id,
      name: translatedName,
      category: translatedCategory,
      area: translatedArea,
      imageUrl: recipe.imageUrl,
      instructions: translatedInstructions,
      ingredients: translatedIngredients,
    );
  }
}

