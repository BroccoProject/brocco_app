import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:brocco_app/l10n/generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';

class FloatingNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const FloatingNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = navigationShell.currentIndex;
    final l10n = AppLocalizations.of(context)!;

    final items = [
      _NavItem(
          label: l10n.profile, icon: Icons.person_outline_rounded, route: '/profile'),
      _NavItem(label: l10n.kitchen, icon: Icons.soup_kitchen_outlined, route: '/'),
      _NavItem(label: l10n.search, icon: Icons.search_rounded, route: '/browser'),
      _NavItem(
          label: l10n.settings, icon: Icons.settings_outlined, route: '/settings'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.accentGreen, width: 2),
          boxShadow: const [
            BoxShadow(
              color: AppColors.accentGreen,
              offset: Offset(0, 5),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final item = items[i];
            final isSelected = i == selectedIndex;
            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => navigationShell.goBranch(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.accentGreen.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                    border: isSelected
                        ? Border.all(
                            color: AppColors.accentGreen.withValues(alpha: 0.5),
                            width: 1.5,
                          )
                        : null,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.accentGreen.withValues(alpha: 0.3),
                              offset: const Offset(0, 3),
                              blurRadius: 0,
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        size: 24,
                        color: isSelected
                            ? AppColors.primaryOrange
                            : AppColors.greyText,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.w900
                              : FontWeight.w700,
                          color: isSelected
                              ? AppColors.primaryText
                              : AppColors.greyText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final String route;
  const _NavItem({required this.label, required this.icon, required this.route});
}
