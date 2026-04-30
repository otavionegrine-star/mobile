import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dashboard_screen.dart';
import 'atividades_screen.dart';
import 'settings_screen.dart';
import '../providers/settings_provider.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  // Índice da página atualmente selecionada na barra inferior.
  int _currentIndex = 1;

  // Páginas que podem ser exibidas pela navegação inferior.
  final _pages = [
    const DashboardScreen(),
    const AtividadesScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Atualiza o nome exibido na AppBar sempre que o provider muda.
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fit Life'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                settings.username,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        // A barra de navegação troca entre as telas definidas em _pages.
        destinations: const [
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Status'),
          NavigationDestination(icon: Icon(Icons.playlist_add_check), label: 'Treinos'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Ajustes'),
        ],
      ),
    );
  }
}