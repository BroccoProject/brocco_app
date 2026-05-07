import 'package:flutter_test/flutter_test.dart';
import 'package:brocco_app/features/game/models/game_state.dart';
import 'package:brocco_app/shared/models/recipe_step.dart';
import 'package:brocco_app/shared/models/ingredient.dart';
import 'package:brocco_app/shared/models/item.dart';

RecipeStep _makeStep(int number, {
  List<StepIngredient> ingredients = const [],
  List<Item> items = const [],
}) {
  return RecipeStep(
    id: 'step-$number',
    stepNumber: number,
    instruction: 'Krok $number',
    ingredients: ingredients,
    items: items,
  );
}

void main() {
  group('GameState – stan domyślny', () {
    const state = GameState();

    test('isFinished jest false gdy steps jest puste', () {
      expect(state.isFinished, isFalse);
    });

    test('currentStep jest null gdy steps jest puste', () {
      expect(state.currentStep, isNull);
    });

    test('progress wynosi 0.0 gdy steps jest puste', () {
      expect(state.progress, 0.0);
    });
  });

  group('GameState – nawigacja po krokach', () {
    final steps = [_makeStep(1), _makeStep(2), _makeStep(3)];
    final state = GameState(steps: steps, currentStepIndex: 0);

    test('currentStep zwraca pierwszy krok przy index 0', () {
      expect(state.currentStep, steps[0]);
    });

    test('isFinished jest false gdy currentStepIndex < steps.length', () {
      expect(state.isFinished, isFalse);
    });

    test('isFinished jest true gdy currentStepIndex >= steps.length', () {
      final finished = state.copyWith(currentStepIndex: 3);
      expect(finished.isFinished, isTrue);
    });

    test('currentStep jest null gdy gra zakończona', () {
      final finished = state.copyWith(currentStepIndex: 3);
      expect(finished.currentStep, isNull);
    });

    test('progress wynosi 0.5 w połowie kroków', () {
      final mid = state.copyWith(currentStepIndex: 1);
      expect(mid.progress, closeTo(1 / 3, 0.001));
    });

    test('progress wynosi 1.0 po ostatnim kroku', () {
      final done = state.copyWith(currentStepIndex: 3);
      expect(done.progress, closeTo(1.0, 0.001));
    });
  });

  group('GameState – currentStepTools i currentStepActions', () {
    final item1 = const Item(id: 'i1', name: 'Nóż', tag: 'knife');
    final item2 = const Item(id: 'i2', name: 'Patelnia', tag: 'pan');
    final ingredient = const Ingredient(id: 'ing1', name: 'Cebula');

    final stepWithTools = RecipeStep(
      id: 's1',
      stepNumber: 1,
      instruction: 'Krój',
      items: [item1, item2],
      ingredients: [
        StepIngredient(
          ingredient: ingredient,
          actions: ['chop', 'fry'],
        ),
      ],
    );

    final state = GameState(steps: [stepWithTools], currentStepIndex: 0);

    test('currentStepTools zwraca tagi itemów', () {
      expect(state.currentStepTools, containsAll(['knife', 'pan']));
    });

    test('currentStepActions zwraca unikalne akcje składników', () {
      expect(state.currentStepActions, containsAll(['chop', 'fry']));
    });

    test('currentStepText zwraca instrukcję bieżącego kroku', () {
      expect(state.currentStepText, 'Krój');
    });
  });

  group('GameState.copyWith', () {
    const original = GameState(recipeId: 'r1', currentStepIndex: 0, isLoading: false);

    test('copyWith zmienia isLoading nie ruszając reszty', () {
      final updated = original.copyWith(isLoading: true);
      expect(updated.isLoading, isTrue);
      expect(updated.recipeId, 'r1');
      expect(updated.currentStepIndex, 0);
    });

    test('copyWith zwiększa currentStepIndex', () {
      final updated = original.copyWith(currentStepIndex: 2);
      expect(updated.currentStepIndex, 2);
      expect(updated.recipeId, 'r1');
    });
  });
}
