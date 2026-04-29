import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/recipe.dart';
import '../../../shared/models/recipe_difficulty.dart';

class RecipeBrowserCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeBrowserCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        '/recipe/${recipe.id}?recipeTitle=${Uri.encodeComponent(recipe.title)}',
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.accentGreen,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.accentGreen,
              offset: Offset(0, 5),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroImage(context),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: const TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (recipe.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      recipe.description!,
                      style: const TextStyle(
                        color: AppColors.greyText,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: (recipe.tags ?? [])
                                .map((tag) => _buildSmallTag(tag))
                                .toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildDifficultyRating(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
          child: recipe.imageUrl != null
              ? Image.network(
                  recipe.imageUrl!,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildPlaceholder(),
                )
              : _buildPlaceholder(),
        ),

        // Time Badge - Top Right
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.accentGreen, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 16,
                  color: AppColors.primaryText,
                ),
                const SizedBox(width: 4),
                Text(
                  '${recipe.durationMinutes ?? 0} min',
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: 180,
      color: AppColors.accentGreen.withOpacity(0.2),
      child: const Center(
        child: Icon(Icons.restaurant, size: 40, color: AppColors.accentGreen),
      ),
    );
  }

  Widget _buildSmallTag(String tag) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.accentGreen, width: 1.2),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          color: AppColors.primaryText,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildDifficultyRating() {
    final diff = RecipeDifficulty.fromString(recipe.difficultyLevel);
    int stars = diff.starCount;
    String label = diff.label;
    Color color = const Color(0xFFF7941D);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: List.generate(3, (index) {
            final isFilled = index < stars;
            return Icon(
              Icons.star,
              size: 14,
              color: isFilled ? color : color.withOpacity(0.2),
            );
          }),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
