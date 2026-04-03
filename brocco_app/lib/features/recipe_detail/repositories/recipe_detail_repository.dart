import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/models/recipe.dart';
import '../models/ingredient.dart';
import '../../../shared/repositories/dtos/recipe_dto.dart';
import 'dtos/ingredient_dto.dart';
import '../models/recipe_step.dart';
import '../models/item.dart';
import 'dtos/recipe_step_dto.dart';
import 'dtos/item_dto.dart';

class RecipeDetailRepository {
  final SupabaseClient _client;

  RecipeDetailRepository(this._client);

  Future<({Recipe recipe, List<Ingredient> ingredients})> getRecipeDetail(
    String recipeId,
  ) async {
    // Single query to fetch recipe, its steps (with ingredients/items),
    // and overall recipe ingredients.
    final response = await _client.from('recipes').select('''
          *,
          recipe_steps(*, 
            step_ingredients(*, ingredients(*)),
            step_items(*, items(*))
          ),
          recipe_ingredients(*, ingredients(*))
        ''').eq('id', recipeId).single();

    final recipeDto = RecipeDto.fromJson(response);

    // recipe_ingredients join result for the main shopping list
    final ingredientDtos = (response['recipe_ingredients'] as List<dynamic>)
        .map((e) => IngredientDto.fromJson(e as Map<String, dynamic>))
        .toList();

    return (
      recipe: _mapRecipe(recipeDto),
      ingredients: ingredientDtos.map(_mapIngredient).toList(),
    );
  }

  Recipe _mapRecipe(RecipeDto dto) {
    return Recipe(
      id: dto.id,
      title: dto.title,
      titleI18n: dto.titleI18n,
      description: dto.description,
      descriptionI18n: dto.descriptionI18n,
      imageUrl: dto.imageUrl,
      difficultyLevel: dto.difficultyLevel,
      durationMinutes: dto.durationMinutes,
      youtubeUrl: dto.youtubeUrl,
      tags: dto.tags,
      category: dto.category,
      area: dto.area,
      sourceUrl: dto.sourceUrl,
      steps: dto.steps.map(_mapStep).toList(),
    );
  }

  Ingredient _mapIngredient(IngredientDto dto) {
    return Ingredient(
      id: dto.id,
      name: dto.name,
      nameI18n: dto.nameI18n,
      amount: dto.amount,
      unit: dto.unit,
      sortOrder: dto.sortOrder,
    );
  }

  RecipeStep _mapStep(RecipeStepDto dto) {
    return RecipeStep(
      id: dto.id,
      stepNumber: dto.stepNumber,
      instruction: dto.instruction,
      instructionI18n: dto.instructionI18n,
      durationSeconds: dto.durationSeconds,
      ingredients: dto.ingredients.map(_mapStepIngredient).toList(),
      items: dto.items.map(_mapItem).toList(),
    );
  }

  StepIngredient _mapStepIngredient(StepIngredientDto dto) {
    return StepIngredient(
      ingredient: _mapIngredient(dto.ingredient),
      amount: dto.amount,
      unit: dto.unit,
      actions: dto.actions,
    );
  }

  Item _mapItem(ItemDto dto) {
    return Item(
      id: dto.id,
      name: dto.name,
      nameI18n: dto.nameI18n,
      tag: dto.tag,
    );
  }
}

final recipeDetailRepositoryProvider = Provider<RecipeDetailRepository>((ref) {
  return RecipeDetailRepository(Supabase.instance.client);
});
