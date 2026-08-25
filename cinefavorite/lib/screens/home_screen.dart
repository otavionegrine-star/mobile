import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';
import '../services/tmdb_service.dart';
import '../database/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = '';
  List<Movie> _searchResults = [];
  List<Movie> _favorites = [];
  bool _isLoading = false;
  final _searchController = TextEditingController();

  static const goldAccent = Color(0xFFD4AF37);
  static const olivePrimary = Color(0xFF3B483B);

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadUser();
    await _loadFavorites();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _userName = prefs.getString('userName') ?? 'Usuário');
  }

  Future<void> _loadFavorites() async {
    if (_userName.isEmpty) return;
    final list = await DBHelper.getFavorites(_userName);
    if (!mounted) return;
    setState(() {
      _favorites = list;
    });
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    setState(() => _isLoading = true);
    try {
      final results = await TmdbService.searchMovies(query);
      setState(() => _searchResults = results);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro na busca: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleFavorite(Movie movie) async {
    final isFav = _favorites.any((m) => m.id == movie.id);
    if (isFav) {
      await DBHelper.removeFavorite(movie.id, _userName);
    } else {
      await DBHelper.addFavorite(movie, _userName);
    }
    await _loadFavorites();
  }

  Future<void> _updateRatingDialog(Movie movie) async {
    double currentRating = movie.rating;
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF2C362C),
              title: Text(
                'Avaliar ${movie.title}',
                style: const TextStyle(color: goldAccent, fontSize: 18),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starValue = index + 1.0;
                      return IconButton(
                        icon: Icon(
                          starValue <= currentRating
                              ? Icons.star
                              : Icons.star_border,
                          color: goldAccent,
                          size: 32,
                        ),
                        onPressed: () {
                          setDialogState(() {
                            currentRating = starValue;
                          });
                        },
                      );
                    }),
                  ),
                  Text(
                    'Nota: ${currentRating.toStringAsFixed(1)} / 5.0',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.white54)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await DBHelper.updateRating(movie.id, _userName, currentRating);
                    await _loadFavorites();
                    if (mounted) Navigator.pop(context);
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Olá, $_userName'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.search), text: 'Buscar'),
              Tab(icon: Icon(Icons.star), text: 'Favoritos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // ABA DE BUSCA
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Buscar filme ou série...',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search, color: goldAccent),
                        onPressed: () => _search(_searchController.text),
                      ),
                    ),
                    onSubmitted: _search,
                  ),
                  const SizedBox(height: 12),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(color: goldAccent),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final movie = _searchResults[index];
                          final isFav = _favorites.any((m) => m.id == movie.id);

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: olivePrimary.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  movie.fullImageUrl,
                                  width: 45,
                                  height: 65,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, _, __) =>
                                      const Icon(Icons.movie, color: goldAccent),
                                ),
                              ),
                              title: Text(
                                movie.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onTap: () => _toggleFavorite(movie),
                              trailing: IconButton(
                                icon: Icon(
                                  isFav ? Icons.favorite : Icons.favorite_border,
                                  color: isFav ? goldAccent : Colors.white54,
                                ),
                                onPressed: () => _toggleFavorite(movie),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),

            // ABA DE FAVORITOS (GRIDVIEW)
            _favorites.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum favorito salvo.',
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _favorites.length,
                    itemBuilder: (context, index) {
                      final movie = _favorites[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: GridTile(
                          footer: Container(
                            color: Colors.black.withOpacity(0.85),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  movie.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () => _updateRatingDialog(movie),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: goldAccent,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            movie.rating > 0
                                                ? movie.rating.toStringAsFixed(1)
                                                : 'Avaliar',
                                            style: const TextStyle(
                                              color: goldAccent,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.redAccent,
                                        size: 20,
                                      ),
                                      onPressed: () => _toggleFavorite(movie),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          child: Image.network(
                            movie.fullImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, _, __) => Container(
                              color: olivePrimary,
                              child: const Icon(
                                Icons.movie,
                                color: goldAccent,
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}