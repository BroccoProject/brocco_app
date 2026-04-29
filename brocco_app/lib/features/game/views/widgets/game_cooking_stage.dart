import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/recipe_step.dart';
import 'filled_tool_icon.dart';
import 'ingredient_label.dart';
import 'tool_icon_map.dart';

class GameCookingStage extends StatelessWidget {
  final List<String> tools;
  final List<StepIngredient> ingredients;
  final int addedCount;
  final double fillFraction;
  final VoidCallback onTap;

  const GameCookingStage({
    super.key,
    required this.tools,
    required this.ingredients,
    required this.addedCount,
    required this.fillFraction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final total = ingredients.length;
    final currentIngredientIndex =
        (total > 0 && addedCount < total) ? addedCount : null;
    final currentIngredient = currentIngredientIndex != null
        ? ingredients[currentIngredientIndex]
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'COOKING STAGE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: AppColors.greyText,
                ),
              ),
              if (total > 0)
                Text(
                  '$addedCount/$total składników',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greyText,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GestureDetector(
              onTap: total > 0 ? onTap : null,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.accentGreen.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: tools.map((tool) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0, end: fillFraction),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOut,
                            builder: (context, value, _) => FilledToolIcon(
                              icon: toolIcon(tool),
                              fillFraction: value,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 110,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, anim) => FadeTransition(
                              opacity: anim,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.3),
                                  end: Offset.zero,
                                ).animate(anim),
                                child: child,
                              ),
                            ),
                            child: currentIngredient != null
                                ? IngredientLabel(
                                    key: ValueKey(currentIngredientIndex),
                                    name: currentIngredient.ingredient.name,
                                    amount: currentIngredient.ingredient.formattedAmount,
                                  )
                                : total > 0
                                    ? const AllAddedBadge(key: ValueKey('done'))
                                    : const SizedBox.shrink(key: ValueKey('empty')),
                          ),
                          if (total > 0 && currentIngredient != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                'Dotknij, aby dodać',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.greyText.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
