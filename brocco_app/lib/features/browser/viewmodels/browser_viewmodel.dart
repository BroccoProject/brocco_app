import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/recipe.dart';
import '../repositories/browser_repository.dart';
import '../../../shared/models/recipe_difficulty.dart';

enum BrowserSortType { none, time, name, difficulty }
enum BrowserSortOrder { asc, desc }

class BrowserFilterCriteria {
  final int? maxTime;
  final List<String> difficulties;

  const BrowserFilterCriteria({
    this.maxTime,
    this.difficulties = const [],
  });

  BrowserFilterCriteria copyWith({
    int? maxTime,
    List<String>? difficulties,
  }) {
    return BrowserFilterCriteria(
      maxTime: maxTime ?? this.maxTime,
      difficulties: difficulties ?? this.difficulties,
    );
  }
}

class BrowserState {
  final List<Recipe> allRecipes;
  final List<Recipe> filteredRecipes;
  final String searchQuery;
  final BrowserSortType sortType;
  final BrowserSortOrder sortOrder;
  final BrowserFilterCriteria filters;
  final bool isLoading;
  final String? errorMessage;

  const BrowserState({
    this.allRecipes = const [],
    this.filteredRecipes = const [],
    this.searchQuery = '',
    this.sortType = BrowserSortType.none,
    this.sortOrder = BrowserSortOrder.asc,
    this.filters = const BrowserFilterCriteria(),
    this.isLoading = false,
    this.errorMessage,
  });

  BrowserState copyWith({
    List<Recipe>? allRecipes,
    List<Recipe>? filteredRecipes,
    String? searchQuery,
    BrowserSortType? sortType,
    BrowserSortOrder? sortOrder,
    BrowserFilterCriteria? filters,
    bool? isLoading,
    String? errorMessage,
  }) {
    return BrowserState(
      allRecipes: allRecipes ?? this.allRecipes,
      filteredRecipes: filteredRecipes ?? this.filteredRecipes,
      searchQuery: searchQuery ?? this.searchQuery,
      sortType: sortType ?? this.sortType,
      sortOrder: sortOrder ?? this.sortOrder,
      filters: filters ?? this.filters,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class BrowserViewModel extends StateNotifier<BrowserState> {
  final BrowserRepository _repository;

  BrowserViewModel(this._repository) : super(const BrowserState()) {
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final recipes = await _repository.getRecipes();
      state = state.copyWith(
        allRecipes: recipes,
        filteredRecipes: recipes,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Could not fetch recipes: $e',
      );
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFiltersAndSort();
  }

  void toggleSort(BrowserSortType type) {
    if (state.sortType == type) {
      final nextOrder = state.sortOrder == BrowserSortOrder.asc
          ? BrowserSortOrder.desc
          : BrowserSortOrder.asc;
      state = state.copyWith(sortOrder: nextOrder);
    } else {
      state = state.copyWith(sortType: type, sortOrder: BrowserSortOrder.asc);
    }
    _applyFiltersAndSort();
  }

  void applyFilters(BrowserFilterCriteria filters) {
    state = state.copyWith(filters: filters);
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    var filtered = List<Recipe>.from(state.allRecipes);

    // 1. Search Query Filter
    if (state.searchQuery.isNotEmpty) {
      final q = state.searchQuery.toLowerCase();
      filtered = filtered
          .where(
            (r) =>
                r.title.toLowerCase().contains(q) ||
                (r.description?.toLowerCase().contains(q) ?? false),
          )
          .toList();
    }

    // 2. Criteria Filter
    if (state.filters.maxTime != null) {
      filtered = filtered
          .where((r) => (r.durationMinutes ?? 0) <= state.filters.maxTime!)
          .toList();
    }

    if (state.filters.difficulties.isNotEmpty) {
      filtered = filtered
          .where(
            (r) => state.filters.difficulties.any(
              (d) => r.difficultyLevel?.toLowerCase() == d.toLowerCase(),
            ),
          )
          .toList();
    }

    // 3. Sorting
    if (state.sortType != BrowserSortType.none) {
      filtered.sort((a, b) {
        int result = 0;
        switch (state.sortType) {
          case BrowserSortType.name:
            result = a.title.compareTo(b.title);
          case BrowserSortType.time:
            result = (a.durationMinutes ?? 0).compareTo(b.durationMinutes ?? 0);
          case BrowserSortType.difficulty:
            result = _difficultyToScore(a.difficultyLevel)
                .compareTo(_difficultyToScore(b.difficultyLevel));
          case BrowserSortType.none:
            result = 0;
        }

        return state.sortOrder == BrowserSortOrder.asc ? result : -result;
      });
    }

    state = state.copyWith(filteredRecipes: filtered);
  }

  int _difficultyToScore(String? level) {
    return RecipeDifficulty.fromString(level).score;
  }
}

final browserViewModelProvider =
    StateNotifierProvider<BrowserViewModel, BrowserState>((ref) {
      final repository = ref.watch(browserRepositoryProvider);
      return BrowserViewModel(repository);
    });
