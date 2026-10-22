// Modelo de dados para representar uma receita
class Recipe {
  final String id;
  final String name;
  final String category;
  final String area;
  final String imageUrl;
  final List<String> instructions;
  final List<String> ingredients;

  Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.imageUrl,
    required this.instructions,
    required this.ingredients,
  });

  // Converte documento do Firestore em objeto Recipe
  factory Recipe.fromMap(Map<String, dynamic> map, String docId) {
    return Recipe(
      id: docId,
      name: map['name'] as String? ?? '',
      category: map['category'] as String? ?? '',
      area: map['area'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      instructions: List<String>.from(map['instructions'] as List? ?? []),
      ingredients: List<String>.from(map['ingredients'] as List? ?? []),
    );
  }

  // Extrai lista de ingredientes da resposta da TheMealDB
  static List<String> _extractIngredients(Map<String, dynamic> meal) {
    final list = <String>[];
    for (int i = 1; i <= 20; i++) {
      final ingredient = meal['strIngredient$i'] as String?;
      final measure = meal['strMeasure$i'] as String?;
      if (ingredient != null && ingredient.trim().isNotEmpty) {
        final text = measure != null && measure.trim().isNotEmpty
            ? '${measure.trim()} ${ingredient.trim()}'
            : ingredient.trim();
        list.add(text);
      }
    }
    return list;
  }

  // Divide texto de instruções em lista de passos
  static List<String> _parseInstructions(String? text) {
    if (text == null || text.trim().isEmpty) return [];
    return text
        .split(RegExp(r'\r?\n+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  // Converte resposta da API TheMealDB em objeto Recipe
  factory Recipe.fromMeal(Map<String, dynamic> meal) {
    return Recipe(
      id: meal['idMeal'] as String? ?? '',
      name: meal['strMeal'] as String? ?? '',
      category: meal['strCategory'] as String? ?? '',
      area: meal['strArea'] as String? ?? '',
      imageUrl: meal['strMealThumb'] as String? ?? '',
      instructions: _parseInstructions(meal['strInstructions'] as String?),
      ingredients: _extractIngredients(meal),
    );
  }

  // Converte objeto Recipe em mapa para o Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'area': area,
      'imageUrl': imageUrl,
      'instructions': instructions,
      'ingredients': ingredients,
    };
  }
}

