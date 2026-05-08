import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/recipe.dart';
import '../models/ingredient.dart';
import 'dtos/recipe_dto.dart';
import 'dtos/ingredient_dto.dart';
import '../models/recipe_step.dart';
import '../models/item.dart';
import 'dtos/recipe_step_dto.dart';
import 'dtos/item_dto.dart';

class RecipeRepository {
  final SupabaseClient _client;

  RecipeRepository(this._client);

  Future<({Recipe recipe, List<Ingredient> ingredients})> getRecipeDetail(
    String recipeId,
  ) async {
    final response = await _client
        .from('recipes')
        .select('''
          *,
          recipe_steps(*, 
            step_ingredients(*, ingredients(*)),
            step_items(*, items(*))
          ),
          recipe_ingredients(*, ingredients(*))
        ''')
        .eq('id', recipeId)
        .order('step_number', referencedTable: 'recipe_steps')
        .single();

    final recipeDto = RecipeDto.fromJson(response);

    return (
      recipe: _mapRecipe(recipeDto),
      ingredients: recipeDto.recipeIngredients.map(_mapIngredient).toList(),
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
      steps: (dto.steps.toList()..sort((a, b) => a.stepNumber.compareTo(b.stepNumber)))
          .map(_mapStep)
          .toList(),
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

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  return RecipeRepository(Supabase.instance.client);
});
