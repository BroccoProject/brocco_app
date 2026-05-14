import 'package:flutter/material.dart';
import 'package:brocco_app/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class DescriptionTab extends StatelessWidget {
  final String? description;

  const DescriptionTab({super.key, this.description});

  @override
  Widget build(BuildContext context) {
    if (description == null || description!.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            AppLocalizations.of(context)!.noDescription,
            style: const TextStyle(
              color: AppColors.greyText,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
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
      child: Text(
        description!,
        style: const TextStyle(
          color: AppColors.primaryText,
          fontSize: 15,
          height: 1.6,
        ),
      ),
    );
  }
}
