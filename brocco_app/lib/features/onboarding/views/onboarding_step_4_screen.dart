import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:brocco_app/l10n/generated/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../shared/widgets/pills/multi_select_pill_group.dart';
import '../../../../../shared/widgets/pills/selectable_pill.dart';
import '../models/onboarding_data.dart';
import '../viewmodels/onboarding_viewmodel.dart';
import '../viewmodels/onboarding_dictionaries_provider.dart';
import 'widgets/onboarding_header.dart';
import 'widgets/onboarding_screen_shell.dart';

class OnboardingStep4Screen extends ConsumerStatefulWidget {
  const OnboardingStep4Screen({super.key});

  @override
  ConsumerState<OnboardingStep4Screen> createState() =>
      _OnboardingStep4ScreenState();
}

class _OnboardingStep4ScreenState extends ConsumerState<OnboardingStep4Screen> {
  EatingStyle? _selectedEatingStyle;
  final List<String> _selectedCuisines = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final d = ref.read(onboardingViewModelProvider);
      if (!mounted) return;
      setState(() {
        _selectedEatingStyle = d.eatingStyle;
        _selectedCuisines
          ..clear()
          ..addAll(d.favoriteCuisines);
      });
    });
  }

  String _eatingStyleLabel(EatingStyle style, AppLocalizations l10n) {
    switch (style) {
      case EatingStyle.omnivore:
        return l10n.eatEverything;
      case EatingStyle.flexitarian:
        return l10n.meatLess;
      case EatingStyle.vegetarian:
        return l10n.vegetarian;
      case EatingStyle.vegan:
        return l10n.vegan;
      case EatingStyle.pescatarian:
        return l10n.fishOnly;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isFormValid = _selectedEatingStyle != null;

    return OnboardingScreenShell(
      currentStep: 4,
      totalSteps: 7,
      scrollable: true,
      onBack: () => context.pop(),
      primaryButtonText: l10n.continueText,
      onPrimaryPressed: !isFormValid
          ? null
          : () {
              ref.read(onboardingViewModelProvider.notifier).updateTastes(
                    eatingStyle: _selectedEatingStyle,
                    favoriteCuisines: List<String>.from(_selectedCuisines),
                  );
              context.push('/onboarding/step_5');
            },
      content: ref.watch(onboardingDictionariesProvider).when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(l10n.errorLoadingDictionaries(error.toString())),
              ),
            ),
            data: (dictionaries) {
              final availableCuisines = dictionaries['cuisines'] ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OnboardingHeader(
                    title: l10n.styleAndFlavors,
                    subtitle: l10n.onboardingStep4Subtitle,
                  ),
                  const SizedBox(height: 32),
                  _SectionTitle(title: l10n.eatingStyle),
                  Wrap(
                    spacing: 10,
                    runSpacing: 12,
                    children: EatingStyle.values.map((style) {
                      return SelectablePill(
                        text: _eatingStyleLabel(style, l10n),
                        isSelected: _selectedEatingStyle == style,
                        onTap: () =>
                            setState(() => _selectedEatingStyle = style),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  _SectionTitle(title: l10n.favoriteCuisinesOptional),
                  MultiSelectPillGroup(
                    items: availableCuisines,
                    selectedItems: _selectedCuisines,
                    onToggle: (item) {
                      setState(() {
                        if (_selectedCuisines.contains(item)) {
                          _selectedCuisines.remove(item);
                        } else {
                          _selectedCuisines.add(item);
                        }
                      });
                    },
                  ),
                ],
              );
            },
          ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primaryText,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
