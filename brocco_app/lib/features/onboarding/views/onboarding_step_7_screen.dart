import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:brocco_app/l10n/generated/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../models/onboarding_data.dart';
import '../viewmodels/onboarding_viewmodel.dart';
import 'widgets/onboarding_header.dart';
import 'widgets/onboarding_screen_shell.dart';

class OnboardingStep7Screen extends ConsumerStatefulWidget {
  const OnboardingStep7Screen({super.key});

  @override
  ConsumerState<OnboardingStep7Screen> createState() =>
      _OnboardingStep7ScreenState();
}

class _OnboardingStep7ScreenState extends ConsumerState<OnboardingStep7Screen> {
  final _weightController = TextEditingController();
  final _targetWeightController = TextEditingController();
  ActivityLevel _activityLevel = ActivityLevel.moderate;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final d = ref.read(onboardingViewModelProvider);
      if (!mounted) return;
      setState(() {
        _activityLevel = d.activityLevel ?? ActivityLevel.moderate;
        if (d.currentWeightKg != null) {
          _weightController.text = _formatWeight(d.currentWeightKg!);
        }
        if (d.targetWeightKg != null) {
          _targetWeightController.text = _formatWeight(d.targetWeightKg!);
        }
      });
    });
  }

  String _formatWeight(double w) {
    final s = w.toStringAsFixed(1);
    return s.endsWith('.0') ? w.toStringAsFixed(0) : s;
  }

  @override
  void dispose() {
    _weightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  bool _canProceed(bool showTargetWeight) {
    return _weightController.text.trim().isNotEmpty &&
        (!showTargetWeight || _targetWeightController.text.trim().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final onboardingData = ref.watch(onboardingViewModelProvider);
    final l10n = AppLocalizations.of(context)!;
    final showTargetWeight =
        onboardingData.mainGoal == MainGoal.loseWeight ||
            onboardingData.mainGoal == MainGoal.buildMuscle;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: OnboardingScreenShell(
        currentStep: 7,
        totalSteps: 7,
        onBack: () => context.pop(),
        scrollable: true,
        primaryButtonText: _isLoading ? l10n.saving : l10n.finishAndCalculate,
        onPrimaryPressed: !_canProceed(showTargetWeight) || _isLoading
            ? null
            : () async {
                final weight = double.tryParse(
                  _weightController.text.replaceAll(',', '.').trim(),
                );
                if (weight == null || weight < 20 || weight > 300) {
                  _showError(l10n.invalidWeight);
                  return;
                }

                double? targetWeight;
                if (showTargetWeight) {
                  targetWeight = double.tryParse(
                    _targetWeightController.text.replaceAll(',', '.').trim(),
                  );
                  if (targetWeight == null ||
                      targetWeight < 20 ||
                      targetWeight > 300) {
                    _showError(l10n.invalidTargetWeight);
                    return;
                  }
                }

                setState(() => _isLoading = true);

                ref.read(onboardingViewModelProvider.notifier).updateBiometrics(
                      currentWeightKg: weight,
                      targetWeightKg: targetWeight,
                      activityLevel: _activityLevel,
                    );
                try {
                  await ref
                      .read(onboardingViewModelProvider.notifier)
                      .completeOnboarding();
                  if (context.mounted) {
                    context.go('/');
                  }
                } catch (e) {
                  setState(() => _isLoading = false);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                }
              },
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OnboardingHeader(
              title: l10n.weightAndActivity,
              subtitle: l10n.dataCaloricProfile,
            ),
            const SizedBox(height: 32),
            _BiometricField(
              label: l10n.weightKg,
              controller: _weightController,
              onChanged: () => setState(() {}),
            ),
            if (showTargetWeight) ...[
              const SizedBox(height: 16),
              _BiometricField(
                label: l10n.targetWeightKg,
                controller: _targetWeightController,
                onChanged: () => setState(() {}),
              ),
            ],
            const SizedBox(height: 24),
            _Label(l10n.physicalActivity),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.greyText.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryText.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<ActivityLevel>(
                  value: _activityLevel,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.accentGreen,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: ActivityLevel.sedentary,
                      child: Text(l10n.activityLow),
                    ),
                    DropdownMenuItem(
                      value: ActivityLevel.moderate,
                      child: Text(l10n.activityModerate),
                    ),
                    DropdownMenuItem(
                      value: ActivityLevel.active,
                      child: Text(l10n.activityHigh),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _activityLevel = val);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.primaryText,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}

class _BiometricField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback onChanged;

  const _BiometricField({
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (_) => onChanged(),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.greyText, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.greyText.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.greyText.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryText, width: 2),
        ),
      ),
    );
  }
}
