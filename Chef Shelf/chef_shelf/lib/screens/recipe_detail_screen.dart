// Tela de detalhes com tradução de página e modo cozinha
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/firestore_service.dart';
import '../services/recipe_api.dart';
import '../services/translation_service.dart';
import '../theme/app_colors.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final _firestore = FirestoreService();
  final _api = RecipeApi();
  final _translation = TranslationService();
  final Set<int> _checkedIngredients = {};
  late Future<Recipe> _future;
  Recipe? _translatedRecipe;
  bool _isTranslated = false;
  bool _translating = false;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _future = _loadRecipe();
    _checkSaved();
  }

  // Carrega receita com detalhes completos
  Future<Recipe> _loadRecipe() async {
    if (widget.recipe.instructions.isNotEmpty) return widget.recipe;
    return _api.details(widget.recipe.id);
  }

  // Verifica se a receita está salva no caderno
  Future<void> _checkSaved() async {
    final saved = await _firestore.isSaved(widget.recipe.id);
    if (mounted) setState(() => _isSaved = saved);
  }

  // Alterna a tradução da receita entre Português e Original
  Future<void> _toggleTranslation(Recipe original) async {
    if (_isTranslated) {
      setState(() => _isTranslated = false);
      return;
    }
    if (_translatedRecipe != null) {
      setState(() => _isTranslated = true);
      return;
    }
    setState(() => _translating = true);
    try {
      final trans = await _translation.translateRecipe(original);
      if (mounted) setState(() { _translatedRecipe = trans; _isTranslated = true; });
    } finally {
      if (mounted) setState(() => _translating = false);
    }
  }

  // Alterna salvamento da receita no caderno
  Future<void> _toggleSave(Recipe recipe) async {
    if (_isSaved) {
      await _firestore.deleteRecipe(recipe.id);
      if (mounted) setState(() => _isSaved = false);
    } else {
      await _firestore.saveRecipe(recipe);
      if (mounted) setState(() => _isSaved = true);
    }
  }

  // Cabeçalho da imagem hero com botões de ação e tradução
  Widget _buildHeroImage(Recipe recipe) {
    return Stack(
      children: [
        Image.network(
          recipe.imageUrl,
          height: 290,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(height: 290, color: AppColors.surfaceContainer),
        ),
        Container(
          height: 290,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withAlpha(90), Colors.transparent, Colors.black.withAlpha(60)],
            ),
          ),
        ),
        Positioned(
          top: 36,
          left: 14,
          child: CircleAvatar(
            backgroundColor: Colors.white.withAlpha(220),
            child: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.onSurface), onPressed: () => Navigator.pop(context)),
          ),
        ),
        Positioned(
          top: 36,
          right: 14,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: _isTranslated ? AppColors.primaryContainer : Colors.white.withAlpha(220),
                child: IconButton(
                  icon: Icon(Icons.translate, size: 20, color: _isTranslated ? Colors.white : AppColors.primaryContainer),
                  tooltip: _isTranslated ? 'Ver original' : 'Traduzir página',
                  onPressed: () => _toggleTranslation(recipe),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Colors.white.withAlpha(220),
                child: IconButton(
                  icon: Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border, color: AppColors.primaryContainer),
                  onPressed: () => _toggleSave(recipe),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Pílula com opção de traduzir a página
  Widget _buildTranslatePill(Recipe recipe) {
    return ActionChip(
      avatar: _translating
          ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
          : Icon(Icons.g_translate, size: 16, color: _isTranslated ? Colors.white : AppColors.primary),
      backgroundColor: _isTranslated ? AppColors.primaryContainer : AppColors.surfaceContainer,
      label: Text(
        _isTranslated ? 'Receita Traduzida (pt-BR) • Ver Original' : 'Traduzir página para Português',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _isTranslated ? Colors.white : AppColors.primary),
      ),
      onPressed: _translating ? null : () => _toggleTranslation(recipe),
    );
  }

  // Pílulas de atributos culinários
  Widget _buildMetricTags(Recipe recipe) {
    final tags = [
      if (recipe.category.isNotEmpty) '🍝 ${recipe.category}',
      if (recipe.area.isNotEmpty) '🌍 Culinária ${recipe.area}',
      '⏱️ 25 min',
      '🔥 450 kcal',
      'Dificuldade: Fácil',
    ];
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: tags.map((t) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.secondaryContainer.withAlpha(160), borderRadius: BorderRadius.circular(16)),
            child: Text(t, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
          )).toList(),
    );
  }

  // Lista interativa de ingredientes
  Widget _buildIngredients(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Ingredientes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(16)),
              child: Text('${_checkedIngredients.length} de ${items.length} separados', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onPrimaryFixedVariant)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...items.asMap().entries.map((e) {
          final isChecked = _checkedIngredients.contains(e.key);
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 8),
            color: AppColors.surfaceContainerLowest,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: AppColors.outlineVariant.withAlpha(80))),
            child: CheckboxListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              value: isChecked,
              activeColor: AppColors.primaryContainer,
              onChanged: (v) => setState(() => v == true ? _checkedIngredients.add(e.key) : _checkedIngredients.remove(e.key)),
              title: Text(e.value, style: TextStyle(fontSize: 13, decoration: isChecked ? TextDecoration.lineThrough : null, color: isChecked ? AppColors.outline : AppColors.onSurface)),
            ),
          );
        }),
      ],
    );
  }

  // Lista de etapas numeradas do modo de preparo
  Widget _buildInstructions(List<String> steps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Modo de Preparo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
        const SizedBox(height: 12),
        ...steps.asMap().entries.map((e) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.outlineVariant.withAlpha(80))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(10)),
                    child: Center(child: Text('0${e.key + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 13))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(e.value, style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.onSurface))),
                ],
              ),
            )),
      ],
    );
  }

  // Botão flutuante de modo cozinha com proteção de SafeArea
  Widget _buildCookingModeBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.cookingMode,
            foregroundColor: AppColors.cookingModeText,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Iniciando Modo Cozinha Passo a Passo 🍳'))),
          icon: const Icon(Icons.soup_kitchen, size: 22),
          label: const Text('Modo Cozinha (Passo a Passo)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildCookingModeBar(),
      body: FutureBuilder<Recipe>(
        future: _future,
        builder: (context, snapshot) {
          final original = snapshot.data ?? widget.recipe;
          final displayRecipe = (_isTranslated && _translatedRecipe != null) ? _translatedRecipe! : original;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeroImage(original)),
              SliverToBoxAdapter(
                child: Container(
                  transform: Matrix4.translationValues(0, -20, 0),
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2)))),
                      const SizedBox(height: 12),
                      _buildTranslatePill(original),
                      const SizedBox(height: 8),
                      Text(displayRecipe.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                      const SizedBox(height: 10),
                      _buildMetricTags(displayRecipe),
                      const SizedBox(height: 20),
                      _buildIngredients(displayRecipe.ingredients),
                      const SizedBox(height: 20),
                      _buildInstructions(displayRecipe.instructions),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
