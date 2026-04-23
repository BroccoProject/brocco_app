import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/buttons/main_back_button.dart';
import '../viewmodels/browser_viewmodel.dart';
import '../widgets/recipe_browser_card.dart';
import '../widgets/filter_bottom_sheet.dart';

class BrowserScreen extends ConsumerWidget {
  const BrowserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final browserState = ref.watch(browserViewModelProvider);
    final viewModel = ref.read(browserViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 24, 8),
              child: Row(
                children: [
                  MainBackButton(onPressed: () => context.pop()),
                  const SizedBox(width: 12),
                  const Text(
                    'Odkrywaj przepisy',
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.accentGreen,
                    width: 1.5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.accentGreen,
                      offset: Offset(0, 5),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: viewModel.setSearchQuery,
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Czego dzisiaj szukasz, Szefie?',
                    hintStyle: TextStyle(
                      color: AppColors.greyText,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: Icon(Icons.search_rounded, color: AppColors.accentGreen, size: 24),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Sort Chips Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _buildFilterButton(context),
                  const SizedBox(width: 10),
                  _buildSortChip(
                    context,
                    ref,
                    'Czas przyrządzania',
                    BrowserSortType.time,
                    browserState.sortType,
                    browserState.sortOrder,
                  ),
                  const SizedBox(width: 10),
                  _buildSortChip(
                    context,
                    ref,
                    'Nazwa',
                    BrowserSortType.name,
                    browserState.sortType,
                    browserState.sortOrder,
                  ),
                  const SizedBox(width: 10),
                  _buildSortChip(
                    context,
                    ref,
                    'Trudność',
                    BrowserSortType.difficulty,
                    browserState.sortType,
                    browserState.sortOrder,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text.rich(
                          TextSpan(
                            text: 'Znaleziono ',
                            style: const TextStyle(
                              color: AppColors.greyText,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: '${browserState.filteredRecipes.length}',
                                style: const TextStyle(
                                  color: AppColors.primaryText,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const TextSpan(text: ' przepisy'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: browserState.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryOrange,
                              ),
                            )
                          : browserState.errorMessage != null
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Text(
                                  browserState.errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.redAccent),
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(24, 0, 24, 110),
                              itemCount: browserState.filteredRecipes.length,
                              itemBuilder: (context, index) {
                                final recipe = browserState.filteredRecipes[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 24),
                                  child: RecipeBrowserCard(recipe: recipe),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFilterPopup(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryOrange,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: AppColors.darkOrange,
              offset: Offset(0, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.tune_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              'Filtruj',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortChip(
    BuildContext context,
    WidgetRef ref,
    String label,
    BrowserSortType type,
    BrowserSortType currentType,
    BrowserSortOrder currentOrder,
  ) {
    final isSelected = type == currentType;

    return GestureDetector(
      onTap: () => ref.read(browserViewModelProvider.notifier).toggleSort(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentGreen : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.accentGreen,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.primaryText,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w800,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Icon(
                currentOrder == BrowserSortOrder.asc
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                color: Colors.white,
                size: 14,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showFilterPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const FilterBottomSheet(),
    );
  }
}
