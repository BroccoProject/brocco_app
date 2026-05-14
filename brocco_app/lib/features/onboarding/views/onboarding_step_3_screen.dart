import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:brocco_app/l10n/generated/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../shared/widgets/pills/selectable_pill.dart';
import '../models/onboarding_data.dart';
import '../viewmodels/onboarding_viewmodel.dart';
import 'widgets/onboarding_header.dart';
import 'widgets/onboarding_screen_shell.dart';

class OnboardingStep3Screen extends ConsumerStatefulWidget {
  const OnboardingStep3Screen({super.key});

  @override
  ConsumerState<OnboardingStep3Screen> createState() =>
      _OnboardingStep3ScreenState();
}

class _OnboardingStep3ScreenState extends ConsumerState<OnboardingStep3Screen> {
  static const List<int> _timeMinutesOptions = [15, 30, 45, 60, 90, 120];

  int? _selectedTimeMinutes;
  UsageFrequency? _selectedFrequency;

  static int _nearestTimeOption(int? minutes) {
    if (minutes == null) return 30;
    return _timeMinutesOptions.reduce(
      (a, b) => (a - minutes).abs() <= (b - minutes).abs() ? a : b,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final d = ref.read(onboardingViewModelProvider);
      if (!mounted) return;
      setState(() {
        _selectedTimeMinutes = _nearestTimeOption(d.maxCookingTimeMinutes);
        _selectedFrequency = d.usageFrequency;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isFormValid =
        _selectedTimeMinutes != null && _selectedFrequency != null;

    return OnboardingScreenShell(
      currentStep: 3,
      totalSteps: 7,
      scrollable: true,
      onBack: () => context.pop(),
      primaryButtonText: l10n.continueText,
      onPrimaryPressed: !isFormValid
          ? null
          : () {
              ref.read(onboardingViewModelProvider.notifier).updateCookingProfile(
                    maxTime: _selectedTimeMinutes,
                    frequency: _selectedFrequency,
                  );
              context.push('/onboarding/step_4');
            },
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingHeader(
            title: l10n.habitsAndTime,
            subtitle: l10n.onboardingStep3Subtitle,
          ),
          const SizedBox(height: 32),
          _SectionTitle(title: l10n.howMuchTimeForMeal),
          Wrap(
            spacing: 10,
            runSpacing: 12,
            children: _timeMinutesOptions.map((m) {
              return SelectablePill(
                text: l10n.minutesAbbr(m.toString()),
                isSelected: _selectedTimeMinutes == m,
                onTap: () => setState(() => _selectedTimeMinutes = m),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          _SectionTitle(title: l10n.howOftenDoYouCook),
          Wrap(
            spacing: 10,
            runSpacing: 12,
            children: [
              SelectablePill(
                text: l10n.everyday,
                isSelected: _selectedFrequency == UsageFrequency.everyday,
                onTap: () => setState(
                  () => _selectedFrequency = UsageFrequency.everyday,
                ),
              ),
              SelectablePill(
                text: l10n.fewTimesAWeek,
                isSelected: _selectedFrequency == UsageFrequency.fewTimesAWeek,
                onTap: () => setState(
                  () => _selectedFrequency = UsageFrequency.fewTimesAWeek,
                ),
              ),
              SelectablePill(
                text: l10n.onlyWeekends,
                isSelected: _selectedFrequency == UsageFrequency.weekends,
                onTap: () => setState(
                  () => _selectedFrequency = UsageFrequency.weekends,
                ),
              ),
            ],
          ),
        ],
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
