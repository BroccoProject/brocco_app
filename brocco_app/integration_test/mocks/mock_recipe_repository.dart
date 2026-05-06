import 'package:mocktail/mocktail.dart';
import 'package:brocco_app/shared/repositories/recipe_repository.dart';
import 'package:brocco_app/shared/models/recipe.dart';
import 'package:brocco_app/shared/models/ingredient.dart';

class MockRecipeRepository extends Mock implements RecipeRepository {
  MockRecipeRepository();

  factory MockRecipeRepository.withRecipe({required Recipe recipe}) {
    final mock = MockRecipeRepository();
    when(() => mock.getRecipeDetail(any())).thenAnswer(
      (_) async => (recipe: recipe, ingredients: <Ingredient>[]),
    );
    return mock;
  }
}
