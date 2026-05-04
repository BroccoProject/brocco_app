import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:brocco_app/l10n/generated/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../shared/widgets/pills/multi_select_pill_group.dart';
import '../viewmodels/onboarding_viewmodel.dart';
import '../viewmodels/onboarding_dictionaries_provider.dart';
import 'widgets/ingredient_search_field.dart';
import 'widgets/onboarding_header.dart';
import 'widgets/onboarding_screen_shell.dart';

class OnboardingStep5Screen extends ConsumerStatefulWidget {
  const OnboardingStep5Screen({super.key});

  @override
  ConsumerState<OnboardingStep5Screen> createState() =>
      _OnboardingStep5ScreenState();
}

class _OnboardingStep5ScreenState extends ConsumerState<OnboardingStep5Screen> {
  final List<String> _selectedAllergies = [];
  final List<String> _selectedDisliked = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final d = ref.read(onboardingViewModelProvider);
      if (!mounted) return;
      setState(() {
        _selectedAllergies
          ..clear()
          ..addAll(d.allergies);
        _selectedDisliked
          ..clear()
          ..addAll(d.dislikedIngredients);
      });
    });
  }

  void _toggleMultiSelect(String item, List<String> list, AppLocalizations l10n) {
    setState(() {
      if (item == l10n.none) {
        list.clear();
        list.add(l10n.none);
        return;
      }

      if (list.contains(l10n.none)) {
        list.remove(l10n.none);
      }

      if (list.contains(item)) {
        list.remove(item);
      } else {
        list.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return OnboardingScreenShell(
      currentStep: 5,
      totalSteps: 7,
      scrollable: true,
      onBack: () => context.pop(),
      primaryButtonText: l10n.continueText,
      onPrimaryPressed: () {
        final allergies =
            _selectedAllergies.where((e) => e != l10n.none).toList();
        final disliked =
            _selectedDisliked.where((e) => e != l10n.none).toList();

        ref.read(onboardingViewModelProvider.notifier).updateTastes(
              allergies: allergies,
              dislikedIngredients: disliked,
            );
        context.push('/onboarding/step_6');
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
              final availableAllergies = dictionaries['allergies'] ?? [];
              final availableDisliked = dictionaries['ingredients'] ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OnboardingHeader(
                    title: l10n.exclusions,
                    subtitle: l10n.allergiesAvoid,
                  ),
                  const SizedBox(height: 32),
                  _SectionTitle(title: l10n.allergiesIntolerances),
                  MultiSelectPillGroup(
                    items: availableAllergies,
                    selectedItems: _selectedAllergies,
                    onToggle: (item) =>
                        _toggleMultiSelect(item, _selectedAllergies, l10n),
                  ),
                  const SizedBox(height: 32),
                  _SectionTitle(title: l10n.whatDoYouDislikeOptional),
                  IngredientSearchField(
                    availableIngredients: availableDisliked,
                    selectedIngredients: _selectedDisliked,
                    onToggle: (item) =>
                        _toggleMultiSelect(item, _selectedDisliked, l10n),
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
