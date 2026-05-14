import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:brocco_app/l10n/generated/app_localizations.dart';
import '../../../../../shared/widgets/cards/selection_card_with_image.dart';
import '../models/onboarding_data.dart';
import '../viewmodels/onboarding_viewmodel.dart';
import 'widgets/onboarding_header.dart';
import 'widgets/onboarding_screen_shell.dart';

class OnboardingStep2Screen extends ConsumerStatefulWidget {
  const OnboardingStep2Screen({super.key});

  @override
  ConsumerState<OnboardingStep2Screen> createState() =>
      _OnboardingStep2ScreenState();
}

class _OnboardingStep2ScreenState extends ConsumerState<OnboardingStep2Screen> {
  CookingSkill? _selectedSkill;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final skill = ref.read(onboardingViewModelProvider).cookingSkill;
      if (mounted) setState(() => _selectedSkill = skill);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return OnboardingScreenShell(
      currentStep: 2,
      totalSteps: 7,
      scrollable: true,
      onBack: () => context.pop(),
      primaryButtonText: l10n.continueText,
      onPrimaryPressed: _selectedSkill == null
          ? null
          : () {
              ref
                  .read(onboardingViewModelProvider.notifier)
                  .updateCookingProfile(skill: _selectedSkill);
              context.push('/onboarding/step_3');
            },
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingHeader(
            title: l10n.whatIsYourLevel,
            subtitle: l10n.onboardingStep2Subtitle,
          ),
          const SizedBox(height: 24),
          SelectionCardWithImage(
            key: const Key('onboarding_skill_novice'),
            title: l10n.microwaveMaster,
            subtitle: l10n.levelBeginner,
            emoji: '🍿',
            isSelected: _selectedSkill == CookingSkill.novice,
            onTap: () => setState(() => _selectedSkill = CookingSkill.novice),
          ),
          SelectionCardWithImage(
            key: const Key('onboarding_skill_homeCook'),
            title: l10n.homeCook,
            subtitle: l10n.levelIntermediate,
            emoji: '🍳',
            isSelected: _selectedSkill == CookingSkill.homeCook,
            onTap: () => setState(() => _selectedSkill = CookingSkill.homeCook),
          ),
          SelectionCardWithImage(
            key: const Key('onboarding_skill_masterchef'),
            title: l10n.masterChef,
            subtitle: l10n.levelAdvanced,
            emoji: '🔪',
            isSelected: _selectedSkill == CookingSkill.masterchef,
            onTap: () =>
                setState(() => _selectedSkill = CookingSkill.masterchef),
          ),
        ],
      ),
    );
  }
}
