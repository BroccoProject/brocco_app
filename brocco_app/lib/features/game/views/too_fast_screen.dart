import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:brocco_app/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/buttons/primary_button.dart';

class TooFastScreen extends StatelessWidget {
  final String recipeId;
  final String recipeText;
  final String nodeId;
  final String categoryId;
  final String recipeTitle;

  const TooFastScreen({
    super.key,
    required this.recipeId,
    required this.recipeText,
    required this.nodeId,
    required this.categoryId,
    required this.recipeTitle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF2F2), // Light red/orange background
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryOrange.withValues(
                                alpha: 0.2,
                              ),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.timer_off_rounded,
                          size: 100,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        l10n.tooFastTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.primaryOrange.withValues(
                              alpha: 0.3,
                            ),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          l10n.tooFastSubtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.greyText,
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  PrimaryButton(
                    text: l10n.cookAgain,
                    onPressed: () {
                      context.pushReplacement(
                        Uri(
                          path: '/game/play',
                          queryParameters: {
                            'recipeId': recipeId,
                            'recipeText': recipeText,
                            'nodeId': nodeId,
                            'categoryId': categoryId,
                            'recipeTitle': recipeTitle,
                          },
                        ).toString(),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      if (categoryId.isNotEmpty) {
                        context.go('/roadmap/$categoryId');
                      } else {
                        context.go('/');
                      }
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      l10n.backToRoadmap,
                      style: const TextStyle(
                        color: AppColors.greyText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
