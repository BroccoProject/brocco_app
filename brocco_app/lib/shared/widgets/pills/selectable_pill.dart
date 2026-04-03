import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SelectablePill extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectablePill({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryText : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primaryText : AppColors.greyText.withOpacity(0.15),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: AppColors.primaryText.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            if (isSelected)
              BoxShadow(
                color: AppColors.primaryText.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.primaryText,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
      ),
    );
  }
}