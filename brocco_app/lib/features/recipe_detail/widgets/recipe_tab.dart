import 'package:flutter/material.dart';
import 'package:brocco_app/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

import '../../../../shared/models/recipe_step.dart';

class RecipeTab extends StatelessWidget {
  final List<RecipeStep> steps;

  const RecipeTab({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (steps.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            l10n.noRecipeFallback,
            style: const TextStyle(
              color: AppColors.greyText,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: steps.map((step) => _buildStepCard(context, step)).toList(),
      ),
    );
  }

  Widget _buildStepCard(BuildContext context, RecipeStep step) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accentGreen.withValues(alpha: 0.4)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.accentGreen,
            offset: Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accentGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              '${step.stepNumber}',
              style: const TextStyle(
                color: AppColors.primaryOrange,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.instruction,
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                if (step.durationSeconds != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        size: 14,
                        color: AppColors.greyText,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.minutesAbbr('${step.durationSeconds! ~/ 60}'),
                        style: const TextStyle(
                          color: AppColors.greyText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
