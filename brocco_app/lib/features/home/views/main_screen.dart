import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:brocco_app/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/pills/stars_pill.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/category_card.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeViewModelProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      l10n.chooseYourPath,
                      style: const TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const StarsPill(),
                ],
              ),

              const SizedBox(height: 28),

              Expanded(
                child: homeAsync.when(
                  data: (state) {
                    if (state.categories.isEmpty) {
                      return Center(
                        child: Text(
                          l10n.noCategories,
                          style: const TextStyle(
                            color: AppColors.greyText,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        final cat = state.categories[index];
                        final locked = state.isCategoryLocked(cat);
                        return CategoryCard(
                          category: cat,
                          completedMeals: state.completedFor(cat.id),
                          totalMeals: state.totalFor(cat.id),
                          currentStars: state.currentStars,
                          isLocked: locked,
                          onTap: locked
                              ? () => ref
                                    .read(homeViewModelProvider.notifier)
                                    .unlockCategory(cat.id)
                              : () {
                                  context.go('/roadmap/${cat.id}');
                                },
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryOrange,
                    ),
                  ),
                  error: (err, _) => Center(
                    child: Text(
                      l10n.errorWithDetail(err.toString()),
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
