// Cartão elegante para exibição de receita
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../theme/app_colors.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final Widget? trailing;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    this.trailing,
  });

  // Constrói a imagem da receita com bordas arredondadas
  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 82,
        height: 82,
        color: AppColors.softGreen.withAlpha(80),
        child: recipe.imageUrl.isNotEmpty
            ? Image.network(
                recipe.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(Icons.restaurant, color: AppColors.forest),
              )
            : const Icon(Icons.restaurant, color: AppColors.forest),
      ),
    );
  }

  // Constrói badge com a categoria da receita
  Widget _buildCategoryBadge() {
    if (recipe.category.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.softGreen,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        recipe.category.toUpperCase(),
        style: const TextStyle(
          color: AppColors.forest,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  // Constrói os detalhes de texto e região
  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategoryBadge(),
        const SizedBox(height: 4),
        Text(
          recipe.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.ink),
        ),
        if (recipe.area.isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.public, size: 13, color: AppColors.muted),
              const SizedBox(width: 4),
              Text(recipe.area, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
            ],
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildImage(),
              const SizedBox(width: 14),
              Expanded(child: _buildDetails()),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}
