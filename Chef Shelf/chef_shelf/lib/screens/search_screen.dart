// Tela de busca reproduzindo o design system do Chef's Shelf
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/firestore_service.dart';
import '../services/recipe_api.dart';
import '../theme/app_colors.dart';
import 'recipe_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _api = RecipeApi();
  final _firestore = FirestoreService();
  final _chips = const ['Todas', 'Massas', 'Aves', 'Carnes', 'Sobremesas', 'Vegetariana', 'Sopas'];
  String _activeChip = 'Todas';
  List<Recipe> _results = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _search('chicken');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Executa busca na API
  Future<void> _search(String query) async {
    final term = query.trim();
    if (term.isEmpty) return;
    setState(() => _loading = true);
    try {
      final items = await _api.search(term);
      if (mounted) setState(() => _results = items);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao buscar receitas.')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // Constrói cabeçalho com badges
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Buscar Receitas 🔍', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(16)),
              child: const Row(
                children: [
                  CircleAvatar(radius: 3, backgroundColor: AppColors.primaryContainer),
                  SizedBox(width: 4),
                  Text('TheMealDB API', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        const Text('Descubra receitas artesanais com base no que você tem em mãos.', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
      ],
    );
  }

  // Barra de pesquisa com botão limpar
  Widget _buildSearchField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onSubmitted: (v) => _search(v),
            decoration: InputDecoration(
              hintText: 'Buscar ingredientes ou pratos...',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: IconButton(
                icon: const Icon(Icons.close, size: 16),
                onPressed: () {
                  _controller.clear();
                  setState(() => _results = []);
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, shape: BoxShape.circle, border: Border.all(color: AppColors.outlineVariant)),
          child: const Icon(Icons.tune, color: AppColors.primary, size: 20),
        ),
      ],
    );
  }

  // Chips de categoria em carrossel horizontal
  Widget _buildChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _chips.map((c) {
          final isSelected = _activeChip == c;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(c),
              selected: isSelected,
              selectedColor: AppColors.primaryContainer,
              labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.onSurface, fontWeight: FontWeight.w600, fontSize: 12),
              onSelected: (_) {
                setState(() => _activeChip = c);
                _search(c == 'Todas' ? 'chicken' : c);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  // Cartão com resultado detalhado
  Widget _buildCard(Recipe r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
      ),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: r))),
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: Image.network(r.imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, _, _) => Container(height: 160, color: AppColors.surfaceContainer)),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.onSurface)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 14, color: AppColors.secondary),
                      const SizedBox(width: 4),
                      Text(r.area.isNotEmpty ? '${r.area} • 30 min' : '30 min', style: const TextStyle(fontSize: 12, color: AppColors.secondary)),
                      const Spacer(),
                      const Icon(Icons.star, size: 14, color: AppColors.cookingMode),
                      const Text(' 4.9', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: AppColors.secondaryContainer, foregroundColor: AppColors.primary),
                    onPressed: () async {
                      await _firestore.saveRecipe(r);
                      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Salva no caderno!')));
                    },
                    icon: const Icon(Icons.bookmark_add_outlined, size: 16),
                    label: const Text('Salvar no Caderno', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chef’s Shelf'),
        actions: [
          IconButton(
            icon: const Icon(Icons.translate, color: AppColors.primary),
            tooltip: 'Tradução gastronômica',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Receitas com suporte a tradução instantânea em Português!')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        children: [
          _buildHeader(),
          const SizedBox(height: 14),
          _buildSearchField(),
          const SizedBox(height: 12),
          _buildChips(),
          const SizedBox(height: 14),
          if (_loading) const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator())),
          if (!_loading) ..._results.map((r) => _buildCard(r)),
        ],
      ),
    );
  }
}
