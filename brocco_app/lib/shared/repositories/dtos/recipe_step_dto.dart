import 'ingredient_dto.dart';
import 'item_dto.dart';

class RecipeStepDto {
  final String id;
  final int stepNumber;
  final String instruction;
  final Map<String, dynamic> instructionI18n;
  final int? durationSeconds;
  final List<StepIngredientDto> ingredients;
  final List<ItemDto> items;

  const RecipeStepDto({
    required this.id,
    required this.stepNumber,
    required this.instruction,
    this.instructionI18n = const {},
    this.durationSeconds,
    this.ingredients = const [],
    this.items = const [],
  });

  factory RecipeStepDto.fromJson(Map<String, dynamic> json) {
    return RecipeStepDto(
      id: json['id'] as String,
      stepNumber: (json['step_number'] as int?) ?? 0,
      instruction: json['instruction'] as String? ?? '',
      instructionI18n:
          json['instruction_i18n'] as Map<String, dynamic>? ?? const {},
      durationSeconds: json['duration_seconds'] as int?,
      ingredients: (json['step_ingredients'] as List<dynamic>?)
              ?.map((e) => StepIngredientDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      items: (json['step_items'] as List<dynamic>?)
              ?.map((e) => ItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

class StepIngredientDto {
  final IngredientDto ingredient;
  final double? amount;
  final String? unit;
  final List<String> actions;

  const StepIngredientDto({
    required this.ingredient,
    this.amount,
    this.unit,
    this.actions = const [],
  });

  factory StepIngredientDto.fromJson(Map<String, dynamic> json) {
    return StepIngredientDto(
      ingredient: IngredientDto.fromJson(json),
      amount: (json['amount'] as num?)?.toDouble(),
      unit: json['unit'] as String?,
      actions: (json['actions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }
}
