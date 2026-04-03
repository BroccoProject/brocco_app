import 'ingredient.dart';
import 'item.dart';

class RecipeStep {
  final String id;
  final int stepNumber;
  final String instruction;
  final Map<String, dynamic> instructionI18n;
  final int? durationSeconds;
  final List<StepIngredient> ingredients;
  final List<Item> items;

  const RecipeStep({
    required this.id,
    required this.stepNumber,
    required this.instruction,
    this.instructionI18n = const {},
    this.durationSeconds,
    this.ingredients = const [],
    this.items = const [],
  });
}

class StepIngredient {
  final Ingredient ingredient;
  final double? amount;
  final String? unit;
  final List<String> actions;

  const StepIngredient({
    required this.ingredient,
    this.amount,
    this.unit,
    this.actions = const [],
  });
}
