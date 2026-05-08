import 'package:flutter_test/flutter_test.dart';
import 'package:brocco_app/features/game/models/game_state.dart';
import 'package:brocco_app/shared/models/recipe_step.dart';
import 'package:brocco_app/shared/models/ingredient.dart';
import 'package:brocco_app/shared/models/item.dart';

RecipeStep _makeStep(
  int n, {
  List<StepIngredient> ingredients = const [],
  List<Item> items = const [],
}) {
  return RecipeStep(
    id: 'step-$n',
    stepNumber: n,
    instruction: 'Krok $n',
    ingredients: ingredients,
    items: items,
  );
}

void main() {
  group('GameState.isFinished', () {
    test('isFinished jest true gdy currentStepIndex osiąga steps.length', () {
      final state = GameState(
        steps: [_makeStep(1), _makeStep(2)],
        currentStepIndex: 2, 
      );
      expect(state.isFinished, isTrue);
      expect(state.currentStep, isNull);
    });
  });

  group('GameState.progress', () {
    test('progress wynosi 1/3 po pierwszym kroku z trzech', () {
      final state = GameState(
        steps: [_makeStep(1), _makeStep(2), _makeStep(3)],
        currentStepIndex: 1,
      );
      expect(state.progress, closeTo(1 / 3, 0.001));
    });
  });

  group('GameState.currentStepActions - deduplikacja', () {
    test(
      'currentStepActions zwraca unikalne akcje ze wszystkich składników',
      () {
        const ing = Ingredient(id: 'i', name: 'Cebula');
        final step = RecipeStep(
          id: 's',
          stepNumber: 1,
          instruction: 'Podsmaż',
          ingredients: [
            const StepIngredient(ingredient: ing, actions: ['chop', 'fry']),
            const StepIngredient(
              ingredient: ing,
              actions: ['fry', 'season'],
            ), 
          ],
        );
        final state = GameState(steps: [step], currentStepIndex: 0);
        expect(
          state.currentStepActions,
          containsAll(['chop', 'fry', 'season']),
        );
        expect(state.currentStepActions.length, 3); // bez duplikatów
      },
    );
  });
}
