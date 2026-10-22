// Configuração global do tema alinhado ao design system oficial
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  // Borda para campos de formulário
  static OutlineInputBorder _border(Color color, [double width = 1.0]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  // Estilo de campos de texto
  static InputDecorationTheme _inputTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceContainerLowest,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: _border(AppColors.outlineVariant),
      enabledBorder: _border(AppColors.outlineVariant),
      focusedBorder: _border(AppColors.primaryContainer, 1.5),
      hintStyle: const TextStyle(color: AppColors.outline, fontSize: 14),
      labelStyle: const TextStyle(color: AppColors.onSurfaceVariant),
    );
  }

  // Estilo de botões principais
  static FilledButtonThemeData _buttonTheme() {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primaryContainer,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Tema completo Material 3
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        error: AppColors.error,
        onError: AppColors.onPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.primary,
        elevation: 0.5,
        scrolledUnderElevation: 1,
        centerTitle: true,
        titleTextStyle: TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: AppColors.primary),
      ),
      inputDecorationTheme: _inputTheme(),
      filledButtonTheme: _buttonTheme(),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        elevation: 4,
        indicatorColor: AppColors.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.onPrimaryContainer);
          }
          return const IconThemeData(color: AppColors.onSurfaceVariant);
        }),
      ),
    );
  }
}
