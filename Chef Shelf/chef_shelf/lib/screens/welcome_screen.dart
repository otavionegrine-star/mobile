// Tela de boas-vindas reproduzindo fielmente a identidade do Chef's Shelf
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // Constrói o emblema da marca com o chapéu de chef e folha fresca
  Widget _buildBrandLogo() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.outlineVariant.withAlpha(100)),
            boxShadow: [
              BoxShadow(
                color: AppColors.onBackground.withAlpha(15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.menu_book_rounded, color: AppColors.primaryContainer, size: 32),
          ),
        ),
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: AppColors.tertiaryFixed,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.eco, size: 14, color: AppColors.tertiaryContainer),
          ),
        ),
      ],
    );
  }

  // Constrói cabeçalho com nome e gancho gastronômico
  Widget _buildHeader() {
    return Column(
      children: [
        _buildBrandLogo(),
        const SizedBox(height: 12),
        const Text(
          "Chef’s Shelf",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: -0.5),
        ),
        const SizedBox(height: 2),
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('por ', style: TextStyle(fontSize: 12, color: AppColors.secondary, fontWeight: FontWeight.w500)),
            Text('GourmetGo', style: TextStyle(fontSize: 13, color: AppColors.tertiary, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 14),
        const Text(
          'Suas receitas favoritas,\nsempre à mão.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface, height: 1.25),
        ),
      ],
    );
  }

  // Constrói o cartão de fotografia hero com badge flutuante
  Widget _buildHeroCard() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 250,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=800&q=80',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: AppColors.surfaceContainer,
                child: const Icon(Icons.restaurant, size: 64, color: AppColors.primaryContainer),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 18,
          left: 18,
          right: 18,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest.withAlpha(240),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.tertiaryFixed,
                  child: Icon(Icons.star, size: 18, color: AppColors.tertiary),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mais de 5.000 receitas', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                    Text('Integrado via TheMealDB API', style: TextStyle(fontSize: 11, color: AppColors.secondary)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Constrói as pílulas com atributos do aplicativo
  Widget _buildMicroPills() {
    const pills = [
      (Icons.timer_outlined, 'Passo a passo'),
      (Icons.bookmark_added_outlined, 'Caderno pessoal'),
      (Icons.restaurant_outlined, 'Modo Cozinha'),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pills.map((p) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer.withAlpha(160),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(p.$1, size: 13, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(p.$2, style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
              ],
            ),
          )).toList(),
    );
  }

  // Constrói os botões de ação na parte inferior
  Widget _buildActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
          icon: const Icon(Icons.arrow_forward, size: 18),
          label: const Text('Começar'),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.surfaceContainerLow,
            side: BorderSide(color: AppColors.outlineVariant.withAlpha(140)),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
          child: const Text('Já tenho uma conta', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 14),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, size: 14, color: AppColors.tertiaryContainer),
            SizedBox(width: 6),
            Text('Desenvolvido com carinho para quem ama cozinhar', style: TextStyle(fontSize: 11, color: AppColors.secondary)),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildHeroCard(),
              const SizedBox(height: 14),
              _buildMicroPills(),
              const SizedBox(height: 24),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }
}

