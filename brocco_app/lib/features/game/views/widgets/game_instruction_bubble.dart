import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class GameInstructionBubble extends StatelessWidget {
  final int stepNumber;
  final String? stepText;

  const GameInstructionBubble({
    super.key,
    required this.stepNumber,
    required this.stepText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Image.asset(
            'assets/images/mascot_cheerful.png',
            width: 90,
            height: 90,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.accentGreen.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('🥦', style: TextStyle(fontSize: 48)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 130,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentGreen.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Krok $stepNumber:',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        stepText ?? 'Przetwarzanie przepisu...',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
