import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/atividade_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/home_screen.dart';

void main() => runApp(
  // Registra todos os providers usados pelo app.
  // O AtividadeProvider fornece dados de atividades e o SettingsProvider controla tema e nome do usuário.
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AtividadeProvider()),
      ChangeNotifierProvider(create: (_) => SettingsProvider()),
    ],
    child: const FitLifeApp(),
  ),
);

class FitLifeApp extends StatelessWidget {
  const FitLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    return MaterialApp(
      title: 'Fit Life',
      debugShowCheckedModeBanner: false,
      // Aplica tema claro ou escuro com base na configuração do usuário.
      themeMode: settingsProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}