import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brocco_app/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/settings_viewmodel.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsViewModelProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF2FAF5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    l10n.kitchenSettings,
                    style: const TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildPremiumBanner(l10n),
              const SizedBox(height: 32),

              settingsAsync.when(
                data: (settings) {
                  if (settings == null) {
                    return Center(child: Text(l10n.errorLoadingSettings));
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(l10n.duringCooking),
                      _buildSectionCard([
                        _buildSwitchTile(
                          title: l10n.screenAlwaysOn,
                          subtitle: l10n.dontTurnOffScreen,
                          value: settings.keepScreenOn,
                          onChanged: (val) => ref
                              .read(settingsActionProvider.notifier)
                              .updatePreference('keep_screen_on', val),
                        ),
                        _buildDivider(),
                        _buildSwitchTile(
                          title: l10n.timerAlarms,
                          subtitle: l10n.beepOnTimerEnd,
                          value: settings.timerAlarms,
                          onChanged: (val) => ref
                              .read(settingsActionProvider.notifier)
                              .updatePreference('timer_alarms', val),
                        ),
                        _buildDivider(),
                        _buildSwitchTile(
                          title: l10n.mascotSounds,
                          subtitle: l10n.broccoComments,
                          value: settings.mascotSounds,
                          onChanged: (val) => ref
                              .read(settingsActionProvider.notifier)
                              .updatePreference('mascot_sounds', val),
                        ),
                      ]),
                      const SizedBox(height: 32),

                      _buildSectionHeader(l10n.preferences),
                      _buildSectionCard([
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.dietaryRules,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.dietaryPreferencesDescription,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.greyText,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.lock_outline,
                                    size: 18,
                                  ),
                                  label: Text(l10n.editDiets),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryOrange,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                      const SizedBox(height: 32),

                      _buildSectionHeader(l10n.account),
                      _buildSectionCard([
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.accentGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.refresh,
                              color: AppColors.accentGreen,
                            ),
                          ),
                          title: Text(
                            l10n.restorePurchases,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryText,
                            ),
                          ),
                          subtitle: Text(
                            l10n.recoverProSubscriptions,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.greyText,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: AppColors.greyText,
                            size: 16,
                          ),
                          onTap: () {},
                        ),
                      ]),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text(l10n.errorWithDetail(e.toString()))),
              ),

              const SizedBox(height: 40),

              Center(
                child: TextButton.icon(
                  onPressed: () =>
                      ref.read(authViewModelProvider.notifier).signOut(),
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                  label: Text(
                    l10n.logOut,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 110),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumBanner(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF7941D), Color(0xFFFFC200)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.premium,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.unlockProChef,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.allWorldsNoLimits,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              l10n.upgrade,
              style: const TextStyle(
                color: AppColors.accentGreen,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primaryText,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildSectionCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.accentGreen.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.greyText,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.accentGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.accentGreen.withOpacity(0.1),
      indent: 20,
      endIndent: 20,
    );
  }
}
