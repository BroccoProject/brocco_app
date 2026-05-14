import 'package:flutter/material.dart';
import 'package:brocco_app/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/recipe_difficulty.dart';

class InfoPillsRow extends StatelessWidget {
  final String? difficultyLevel;
  final int? durationMinutes;
  final List<String>? tags;

  const InfoPillsRow({
    super.key,
    this.difficultyLevel,
    this.durationMinutes,
    this.tags,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        if (difficultyLevel != null && difficultyLevel!.isNotEmpty)
          _buildPill(
            child: Text(
              '${l10n.difficultyLevel}: ${RecipeDifficulty.fromString(difficultyLevel!).getLabel(l10n)}',
              style: const TextStyle(
                color: AppColors.primaryText,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        if (durationMinutes != null)
          _buildPill(
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
                  l10n.minutesAbbr('$durationMinutes'),
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        if (tags != null)
          ...tags!.map(
            (tag) => _buildPill(
              child: Text(
                tag,
                style: const TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPill({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accentGreen.withValues(alpha: 0.6),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.accentGreen,
            offset: Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}
