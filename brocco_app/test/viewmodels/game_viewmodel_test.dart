import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:brocco_app/features/game/models/game_state.dart';
import 'package:brocco_app/features/game/viewmodels/game_viewmodel.dart';
import 'package:brocco_app/shared/models/recipe.dart';
import 'package:brocco_app/shared/models/ingredient.dart';
import 'package:brocco_app/shared/models/recipe_step.dart';
import 'package:brocco_app/shared/repositories/recipe_repository.dart';

class MockRecipeRepository extends Mock implements RecipeRepository {}

RecipeStep _step(int n) => RecipeStep(
      id: 'step-$n',
      stepNumber: n,
      instruction: 'Krok $n',
    );

void main() {
  late MockRecipeRepository mockRepo;

  setUp(() {
    mockRepo = MockRecipeRepository();
  });

  ProviderContainer _makeContainer() {
    return ProviderContainer(
      overrides: [
        recipeRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  }

  group('GameViewModel – stan początkowy', () {
    test('buduje z domyślnym GameState', () {
      final container = _makeContainer();
      addTearDown(container.dispose);

      final state = container.read(gameViewModelProvider);
      expect(state.recipeId, '');
      expect(state.steps, isEmpty);
      expect(state.currentStepIndex, 0);
      expect(state.isLoading, isFalse);
    });
  });

  group('GameViewModel – startGame', () {
    final testSteps = [_step(1), _step(2), _step(3)];
    final testRecipe = Recipe(
      id: 'recipe-1',
      title: 'Pizza',
      durationMinutes: 30,
      steps: testSteps,
    );

    test('ustawia isLoading=true podczas ładowania i potem false', () async {
      when(() => mockRepo.getRecipeDetail('recipe-1')).thenAnswer(
        (_) async => (recipe: testRecipe, ingredients: <Ingredient>[]),
      );

      final container = _makeContainer();
      addTearDown(container.dispose);

      final vm = container.read(gameViewModelProvider.notifier);
      await vm.startGame('recipe-1', 'Pizza');

      final state = container.read(gameViewModelProvider);
      expect(state.isLoading, isFalse);
      expect(state.recipeId, 'recipe-1');
      expect(state.steps.length, 3);
      expect(state.currentStepIndex, 0);
      expect(state.durationMinutes, 30);
      expect(state.gameStartTime, isNotNull);
    });

    test('zachowuje isLoading=false gdy repozytorium rzuca wyjątek', () async {
      when(() => mockRepo.getRecipeDetail('bad-id'))
          .thenThrow(Exception('Brak połączenia'));

      final container = _makeContainer();
      addTearDown(container.dispose);

      final vm = container.read(gameViewModelProvider.notifier);
      await vm.startGame('bad-id', 'Unknown');

      final state = container.read(gameViewModelProvider);
      expect(state.isLoading, isFalse);
    });
  });

  group('GameViewModel – nextStep i previousStep', () {
    final steps = [_step(1), _step(2), _step(3)];

    ProviderContainer _containerWithSteps() {
      final c = _makeContainer();
      // Ustawiamy stan bezpośrednio przez copyWith — testujemy logikę bez IO
      c.read(gameViewModelProvider.notifier).state =
          GameState(steps: steps, currentStepIndex: 0);
      return c;
    }

    test('nextStep zwiększa currentStepIndex', () {
      final container = _containerWithSteps();
      addTearDown(container.dispose);

      container.read(gameViewModelProvider.notifier).nextStep();
      expect(container.read(gameViewModelProvider).currentStepIndex, 1);
    });

    test('nextStep nie przekracza ostatniego kroku', () {
      final container = _containerWithSteps();
      addTearDown(container.dispose);
      final vm = container.read(gameViewModelProvider.notifier);

      vm.nextStep(); // 0 → 1
      vm.nextStep(); // 1 → 2
      vm.nextStep(); // 2 → 3 (isFinished)
      vm.nextStep(); // powinien pozostać 3
      expect(container.read(gameViewModelProvider).currentStepIndex, 3);
    });

    test('previousStep zmniejsza currentStepIndex', () {
      final container = _containerWithSteps();
      addTearDown(container.dispose);
      final vm = container.read(gameViewModelProvider.notifier);

      vm.nextStep(); // 0 → 1
      vm.previousStep(); // 1 → 0
      expect(container.read(gameViewModelProvider).currentStepIndex, 0);
    });

    test('previousStep nie schodzi poniżej 0', () {
      final container = _containerWithSteps();
      addTearDown(container.dispose);

      container.read(gameViewModelProvider.notifier).previousStep();
      expect(container.read(gameViewModelProvider).currentStepIndex, 0);
    });
  });

  group('GameViewModel – resetGame', () {
    test('resetuje stan do domyślnego', () async {
      when(() => mockRepo.getRecipeDetail(any())).thenAnswer(
        (_) async => (
          recipe: Recipe(id: 'r', title: 'T', steps: [_step(1)]),
          ingredients: <Ingredient>[],
        ),
      );

      final container = _makeContainer();
      addTearDown(container.dispose);
      final vm = container.read(gameViewModelProvider.notifier);

      await vm.startGame('r', 'T');
      vm.nextStep();
      vm.resetGame();

      final state = container.read(gameViewModelProvider);
      expect(state.recipeId, '');
      expect(state.steps, isEmpty);
      expect(state.currentStepIndex, 0);
    });
  });
}
