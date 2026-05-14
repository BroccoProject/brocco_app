import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'pushable_3d_button.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Pushable3DButton(
        onPressed: isLoading ? null : onPressed,
        backgroundColor: AppColors.primaryOrange,
        shadowColor: const Color(0xFFD6800B),
        shadowOffset: 4.0,
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : Text(
                  text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}