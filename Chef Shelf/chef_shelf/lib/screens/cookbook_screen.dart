// Tela do caderno de receitas salvas com sincronização Firestore
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/firestore_service.dart';
import '../theme/app_colors.dart';
import 'recipe_detail_screen.dart';

class CookbookScreen extends StatefulWidget {
  const CookbookScreen({super.key});

  @override
  State<CookbookScreen> createState() => _CookbookScreenState();
}

class _CookbookScreenState extends State<CookbookScreen> {
  final _firestore = FirestoreService();
  final _searchController = TextEditingController();
  String _filter = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Confirmação de exclusão com modal estilizado
  Future<void> _confirmDelete(BuildContext context, Recipe recipe) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            CircleAvatar(backgroundColor: AppColors.errorContainer, child: Icon(Icons.delete, color: AppColors.error, size: 20)),
            SizedBox(width: 10),
            Text('Remover receita?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text('Remover "${recipe.name}" do seu caderno? Você pode adicioná-la novamente quando quiser.', style: const TextStyle(fontSize: 13, color: AppColors.secondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sim, remover'),
          ),
        ],
      ),
    );
    if (confirmed == true) await _firestore.deleteRecipe(recipe.id);
  }

  // Constrói cabeçalho com indicador de sincronização
  Widget _buildHeader(int count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Meu Caderno 📖', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(16)),
              child: const Text('Firestore Sync', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSecondaryFixed)),
            ),
          ],
        ),
        const SizedBox(height: 2),
        const Text('Todas as suas receitas favoritas em um só lugar', style: TextStyle(fontSize: 12, color: AppColors.secondary)),
        const SizedBox(height: 12),
        TextField(
          controller: _searchController,
          onChanged: (v) => setState(() => _filter = v.trim().toLowerCase()),
          decoration: const InputDecoration(hintText: 'Pesquisar nas minhas receitas...', prefixIcon: Icon(Icons.search, size: 20)),
        ),
      ],
    );
  }

  // Constrói cartão completo de receita salva
  Widget _buildCard(Recipe r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(r.imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, _, _) => Container(height: 160, color: AppColors.surfaceContainer)),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.surface.withAlpha(230),
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                    onPressed: () => _confirmDelete(context, r),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.onSurface)),
                const SizedBox(height: 6),
                const Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 14, color: AppColors.secondary),
                    SizedBox(width: 4),
                    Text('25 min', style: TextStyle(fontSize: 12, color: AppColors.secondary)),
                    SizedBox(width: 14),
                    Icon(Icons.star, size: 14, color: AppColors.cookingMode),
                    SizedBox(width: 4),
                    Text('4.9', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Salvo no caderno', style: TextStyle(fontSize: 11, color: AppColors.secondary)),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(backgroundColor: AppColors.secondaryContainer, foregroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8)),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: r))),
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: const Text('Abrir detalhes', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Estado vazio amigável com opção para explorar
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant, style: BorderStyle.solid),
      ),
      child: const Column(
        children: [
          CircleAvatar(radius: 28, backgroundColor: AppColors.surfaceContainer, child: Icon(Icons.menu_book, color: AppColors.primaryContainer, size: 30)),
          SizedBox(height: 12),
          Text('Seu caderno está esperando por novas receitas!', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
          SizedBox(height: 4),
          Text('Explore o acervo gastronômico e toque no marcador para salvar suas favoritas.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppColors.secondary)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chef’s Shelf')),
      body: StreamBuilder<List<Recipe>>(
        stream: _firestore.watchRecipes(),
        builder: (context, snapshot) {
          final all = snapshot.data ?? [];
          final recipes = _filter.isEmpty ? all : all.where((r) => r.name.toLowerCase().contains(_filter)).toList();
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            children: [
              _buildHeader(all.length),
              const SizedBox(height: 16),
              if (recipes.isEmpty) _buildEmptyState(),
              if (recipes.isNotEmpty) ...recipes.map((r) => _buildCard(r)),
            ],
          );
        },
      ),
    );
  }
}
