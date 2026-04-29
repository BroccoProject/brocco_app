import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class IngredientLabel extends StatelessWidget {
  final String name;
  final String amount;

  const IngredientLabel({super.key, required this.name, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGreen.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryText,
                ),
              ),
              if (amount.isNotEmpty)
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.greyText,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class AllAddedBadge extends StatelessWidget {
  const AllAddedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.accentGreen.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accentGreen.withOpacity(0.4)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: AppColors.primaryText,
            size: 22,
          ),
          SizedBox(width: 8),
          Text(
            'Wszystkie składniki dodane!',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
