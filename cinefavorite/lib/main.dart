import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const CineFavoriteApp());
}

class CineFavoriteApp extends StatelessWidget {
  const CineFavoriteApp({super.key});

  @override
  Widget build(BuildContext context) {
    const oliveDark = Color(0xFF1E241E);
    const olivePrimary = Color(0xFF3B483B);
    const goldAccent = Color(0xFFD4AF37);

    return MaterialApp(
      title: 'CineFavorite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: oliveDark,
        colorScheme: const ColorScheme.dark(
          primary: goldAccent,
          secondary: goldAccent,
          surface: olivePrimary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: oliveDark,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: goldAccent,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: goldAccent,
          unselectedLabelColor: Colors.white60,
          indicatorColor: goldAccent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: olivePrimary.withValues(alpha: 0.5),
          hintStyle: const TextStyle(color: Colors.white54),
          labelStyle: const TextStyle(color: goldAccent),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: olivePrimary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: goldAccent, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: goldAccent,
            foregroundColor: oliveDark,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}