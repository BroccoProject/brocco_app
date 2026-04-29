import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state.dart';
import '../../../shared/repositories/recipe_repository.dart';

final gameViewModelProvider = NotifierProvider<GameViewModel, GameState>(() {
  return GameViewModel();
});

class GameViewModel extends Notifier<GameState> {
  @override
  GameState build() {
    return const GameState();
  }

  Future<void> startGame(String recipeId, String recipeText) async {
    state = state.copyWith(isLoading: true);

    try {
      final repo = ref.read(recipeRepositoryProvider);
      final result = await repo.getRecipeDetail(recipeId);

      state = GameState(
        recipeId: recipeId,
        steps: result.recipe.steps,
        currentStepIndex: 0,
        isLoading: false,
      );
    } catch (e) {
      print('Error fetching recipe for game: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  void nextStep() {
    if (!state.isFinished) {
      state = state.copyWith(currentStepIndex: state.currentStepIndex + 1);
    }
  }

  void previousStep() {
    if (state.currentStepIndex > 0) {
      state = state.copyWith(currentStepIndex: state.currentStepIndex - 1);
    }
  }

  void resetGame() {
    state = const GameState();
  }
}
