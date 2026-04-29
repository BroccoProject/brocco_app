import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/recipe.dart';
import '../../../shared/models/ingredient.dart';
import '../../../shared/repositories/recipe_repository.dart';

class RecipeDetailState {
  final Recipe recipe;
  final List<Ingredient> ingredients;

  const RecipeDetailState({required this.recipe, this.ingredients = const []});
}

class RecipeDetailViewModel
    extends FamilyAsyncNotifier<RecipeDetailState, String> {
  @override
  Future<RecipeDetailState> build(String recipeId) async {
    final repository = ref.read(recipeRepositoryProvider);
    final result = await repository.getRecipeDetail(recipeId);

    return RecipeDetailState(
      recipe: result.recipe,
      ingredients: result.ingredients,
    );
  }
}

final recipeDetailViewModelProvider =
    AsyncNotifierProvider.family<
      RecipeDetailViewModel,
      RecipeDetailState,
      String
    >(() => RecipeDetailViewModel());
