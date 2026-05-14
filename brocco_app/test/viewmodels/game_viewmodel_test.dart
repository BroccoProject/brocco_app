import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:brocco_app/features/game/models/game_state.dart';
import 'package:brocco_app/features/game/viewmodels/game_viewmodel.dart';
import 'package:brocco_app/shared/models/ingredient.dart';
import 'package:brocco_app/shared/models/recipe.dart';
import 'package:brocco_app/shared/models/recipe_step.dart';
import 'package:brocco_app/shared/repositories/recipe_repository.dart';

class MockRecipeRepository extends Mock implements RecipeRepository {}

RecipeStep _step(int n) =>
    RecipeStep(id: 'step-$n', stepNumber: n, instruction: 'Krok $n');

ProviderContainer _makeContainer(MockRecipeRepository mockRepo) {
  return ProviderContainer(
    overrides: [recipeRepositoryProvider.overrideWithValue(mockRepo)],
  );
}

void main() {
  late MockRecipeRepository mockRepo;

  setUp(() => mockRepo = MockRecipeRepository());

  group('GameViewModel.startGame', () {
    test(
      'po udanym starcie ustawia kroki, recipeId i czyści isLoading',
      () async {
        final recipe = Recipe(
          id: 'r1',
          title: 'Pizza',
          durationMinutes: 30,
          steps: [_step(1), _step(2)],
        );
        when(() => mockRepo.getRecipeDetail('r1')).thenAnswer(
          (_) async => (recipe: recipe, ingredients: <Ingredient>[]),
        );

        final container = _makeContainer(mockRepo);
        addTearDown(container.dispose);

        await container
            .read(gameViewModelProvider.notifier)
            .startGame('r1', 'Pizza');

        final state = container.read(gameViewModelProvider);
        expect(state.recipeId, 'r1');
        expect(state.steps.length, 2);
        expect(state.isLoading, isFalse);
        expect(state.gameStartTime, isNotNull);
      },
    );

    test('błąd repozytorium nie zostawia isLoading=true', () async {
      when(
        () => mockRepo.getRecipeDetail(any()),
      ).thenThrow(Exception('Brak połączenia'));

      final container = _makeContainer(mockRepo);
      addTearDown(container.dispose);

      await container
          .read(gameViewModelProvider.notifier)
          .startGame('bad', 'X');

      expect(container.read(gameViewModelProvider).isLoading, isFalse);
    });
  });

  group('GameViewModel - granice nawigacji', () {
    ProviderContainer _containerWithSteps(List<RecipeStep> steps) {
      final c = _makeContainer(mockRepo);
      c.read(gameViewModelProvider.notifier).state = GameState(
        steps: steps,
        currentStepIndex: 0,
      );
      return c;
    }

    test('nextStep nie przekracza granicy steps.length', () {
      final steps = [_step(1), _step(2)];
      final container = _containerWithSteps(steps);
      addTearDown(container.dispose);
      final vm = container.read(gameViewModelProvider.notifier);

      vm.nextStep();
      vm.nextStep();
      vm.nextStep();
      expect(container.read(gameViewModelProvider).currentStepIndex, 2);
    });

    test('previousStep nie schodzi poniżej 0', () {
      final container = _containerWithSteps([_step(1)]);
      addTearDown(container.dispose);

      container.read(gameViewModelProvider.notifier).previousStep();
      expect(container.read(gameViewModelProvider).currentStepIndex, 0);
    });
  });

  group('GameViewModel.resetGame', () {
    test('resetuje stan do początkowego po przejściu kilku kroków', () {
      final container = _makeContainer(mockRepo);
      addTearDown(container.dispose);
      final vm = container.read(gameViewModelProvider.notifier);

      vm.state = GameState(steps: [_step(1), _step(2)], currentStepIndex: 2);
      vm.resetGame();

      final state = container.read(gameViewModelProvider);
      expect(state.recipeId, '');
      expect(state.steps, isEmpty);
      expect(state.currentStepIndex, 0);
    });
  });
}
