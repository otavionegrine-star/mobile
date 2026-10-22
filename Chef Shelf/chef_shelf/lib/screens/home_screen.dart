// Tela inicial reproduzindo o design system e componentes oficiais
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/recipe_api.dart';
import '../theme/app_colors.dart';
import 'cookbook_screen.dart';
import 'profile_screen.dart';
import 'recipe_detail_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabIndex = 0;

  void _switchTab(int index) {
    setState(() => _tabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeFeed(onNavigateSearch: () => _switchTab(1)),
      const SearchScreen(),
      const CookbookScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _tabIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (idx) => setState(() => _tabIndex = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Início'),
          NavigationDestination(icon: Icon(Icons.search_outlined), selectedIcon: Icon(Icons.search), label: 'Buscar'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Meu Caderno'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

// Feed inicial do aplicativo
class HomeFeed extends StatefulWidget {
  final VoidCallback onNavigateSearch;
  const HomeFeed({super.key, required this.onNavigateSearch});

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  final _api = RecipeApi();
  final _firestore = FirestoreService();
  late Future<List<Recipe>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.getSuggestions();
  }

  // Constrói saudação com perfil do usuário
  Widget _buildGreeting() {
    final email = AuthService().currentUser?.email ?? 'Mariana';
    final name = email.contains('@') ? email.split('@').first : email;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Olá, Chef $name! 👋', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
            const SizedBox(height: 2),
            const Text('O que vamos cozinhar hoje?', style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant)),
          ],
        ),
        Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary,
              child: const CircleAvatar(radius: 22, backgroundColor: AppColors.surfaceContainer, child: Icon(Icons.person, color: AppColors.primary)),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(width: 12, height: 12, decoration: BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2))),
            ),
          ],
        ),
      ],
    );
  }

  // Barra de pesquisa rápida
  Widget _buildSearchBar() {
    return InkWell(
      onTap: widget.onNavigateSearch,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: AppColors.outline, size: 20),
            SizedBox(width: 10),
            Expanded(child: Text('Buscar receitas, ingredientes...', style: TextStyle(color: AppColors.outline, fontSize: 13))),
            Icon(Icons.tune, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }

  // Cartão Hero "Receita do Dia"
  Widget _buildHeroRecipe(Recipe recipe) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
        boxShadow: [BoxShadow(color: AppColors.onBackground.withAlpha(12), blurRadius: 18, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  recipe.imageUrl.isNotEmpty ? recipe.imageUrl : 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=800&q=80',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(height: 180, color: AppColors.surfaceContainer, child: const Icon(Icons.restaurant, size: 40)),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.surfaceContainerLowest.withAlpha(240), borderRadius: BorderRadius.circular(20)),
                  child: const Text('🌟 Receita do Dia', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipe.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                const SizedBox(height: 4),
                Text(recipe.area.isNotEmpty ? 'Culinária ${recipe.area} • Deliciosa e aromática' : 'Receita selecionada pelo Chef', style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${recipe.ingredients.length} ingredientes', style: const TextStyle(fontSize: 12, color: AppColors.secondary)),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8)),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe))),
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: const Text('Ver receita', style: TextStyle(fontSize: 12)),
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

  // Carrossel horizontal de categorias com emojis
  Widget _buildCategoryStrip() {
    const categories = [
      ('Massas', '🍝'),
      ('Carnes', '🥩'),
      ('Sobremesas', '🍰'),
      ('Saladas', '🥗'),
      ('Vegetarianas', '🥑'),
      ('Frutos do Mar', '🍤'),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: InkWell(
                onTap: widget.onNavigateSearch,
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
                      ),
                      child: Center(child: Text(cat.$2, style: const TextStyle(fontSize: 22))),
                    ),
                    const SizedBox(height: 6),
                    Text(cat.$1, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                  ],
                ),
              ),
            )).toList(),
      ),
    );
  }

  // Widget flutuante de timer de cozinha
  Widget _buildTimerWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.inverseSurface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: AppColors.onBackground.withAlpha(40), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: const Row(
        children: [
          Icon(Icons.hourglass_top, color: AppColors.tertiaryFixed, size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TIMER EM ANDAMENTO', style: TextStyle(fontSize: 10, letterSpacing: 1, color: AppColors.surfaceVariant, fontWeight: FontWeight.bold)),
                Text('Penne Al Dente • 04:12', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.surface)),
              ],
            ),
          ),
          Text('Pausar', style: TextStyle(color: AppColors.tertiaryFixed, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
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
                const SnackBar(
                  content: Text('Abra qualquer receita para traduzir a página instantaneamente! 🌐'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<List<Recipe>>(
        future: _future,
        builder: (context, snapshot) {
          final recipes = snapshot.data ?? [];
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            children: [
              _buildGreeting(),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 20),
              if (recipes.isNotEmpty) _buildHeroRecipe(recipes.first),
              const SizedBox(height: 24),
              const Text('Explore por Categorias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
              const SizedBox(height: 12),
              _buildCategoryStrip(),
              const SizedBox(height: 24),
              _buildTimerWidget(),
              const SizedBox(height: 20),
              const Text('Descubra Novas Receitas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
              const SizedBox(height: 2),
              const Text('Sincronizadas com o acervo TheMealDB', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
              const SizedBox(height: 12),
              ...recipes.skip(1).take(5).map((r) => _buildRecipeTile(r)),
            ],
          );
        },
      ),
    );
  }

  // Item de receita resumido
  Widget _buildRecipeTile(Recipe r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: r))),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(r.imageUrl, width: 64, height: 64, fit: BoxFit.cover, errorBuilder: (_, _, _) => const Icon(Icons.restaurant)),
        ),
        title: Text(r.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(r.category.isNotEmpty ? r.category : r.area, style: const TextStyle(color: AppColors.secondary, fontSize: 12)),
        trailing: IconButton(
          icon: const Icon(Icons.bookmark_border, color: AppColors.primary),
          onPressed: () => _firestore.saveRecipe(r),
        ),
      ),
    );
  }
}
