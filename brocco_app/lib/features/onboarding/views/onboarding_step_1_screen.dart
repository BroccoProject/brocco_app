import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:brocco_app/l10n/generated/app_localizations.dart';
import '../../../../../shared/widgets/cards/selection_card_with_image.dart';
import '../models/onboarding_data.dart';
import '../viewmodels/onboarding_viewmodel.dart';
import 'widgets/onboarding_header.dart';
import 'widgets/onboarding_screen_shell.dart';

class OnboardingStep1Screen extends ConsumerStatefulWidget {
  const OnboardingStep1Screen({super.key});

  @override
  ConsumerState<OnboardingStep1Screen> createState() =>
      _OnboardingStep1ScreenState();
}

class _OnboardingStep1ScreenState extends ConsumerState<OnboardingStep1Screen> {
  MainGoal? _selectedGoal;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final goal = ref.read(onboardingViewModelProvider).mainGoal;
      if (mounted) setState(() => _selectedGoal = goal);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return OnboardingScreenShell(
      currentStep: 1,
      totalSteps: 7,
      scrollable: true,
      primaryButtonText: l10n.continueText,
      onPrimaryPressed: _selectedGoal == null
          ? null
          : () {
              ref
                  .read(onboardingViewModelProvider.notifier)
                  .updateBiometrics(mainGoal: _selectedGoal);
              context.push('/onboarding/step_2');
            },
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingHeader(
            title: l10n.whatDoYouWantToAchieve,
            subtitle: l10n.onboardingStep1Subtitle,
          ),
          const SizedBox(height: 32),
          SelectionCardWithImage(
            key: const Key('onboarding_goal_eatHealthier'),
            title: l10n.eatHealthier,
            subtitle: l10n.eatHealthierSubtitle,
            icon: Icons.restaurant_rounded,
            isSelected: _selectedGoal == MainGoal.eatHealthier,
            onTap: () => setState(() => _selectedGoal = MainGoal.eatHealthier),
          ),
          const SizedBox(height: 12),
          SelectionCardWithImage(
            title: l10n.loseWeight,
            subtitle: l10n.loseWeightSubtitle,
            icon: Icons.trending_up_rounded,
            isSelected: _selectedGoal == MainGoal.loseWeight,
            onTap: () => setState(() => _selectedGoal = MainGoal.loseWeight),
          ),
          const SizedBox(height: 12),
          SelectionCardWithImage(
            title: l10n.buildMuscle,
            subtitle: l10n.buildMuscleSubtitle,
            icon: Icons.fitness_center_rounded,
            isSelected: _selectedGoal == MainGoal.buildMuscle,
            onTap: () => setState(() => _selectedGoal = MainGoal.buildMuscle),
          ),
          const SizedBox(height: 12),
          SelectionCardWithImage(
            key: const Key('onboarding_goal_learnToCook'),
            title: l10n.learnToCook,
            subtitle: l10n.learnToCookSubtitle,
            icon: Icons.soup_kitchen_rounded,
            isSelected: _selectedGoal == MainGoal.learnToCook,
            onTap: () => setState(() => _selectedGoal = MainGoal.learnToCook),
          ),
          const SizedBox(height: 12),
          SelectionCardWithImage(
            title: l10n.saveTime,
            subtitle: l10n.saveTimeSubtitle,
            icon: Icons.bolt_rounded,
            isSelected: _selectedGoal == MainGoal.saveTime,
            onTap: () => setState(() => _selectedGoal = MainGoal.saveTime),
          ),
        ],
      ),
    );
  }
}
