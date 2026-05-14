import '../../../shared/models/recipe_step.dart';

class GameState {
  final String recipeId;
  final List<RecipeStep> steps;
  final int currentStepIndex;
  final bool isLoading;
  final int durationMinutes;
  final DateTime? gameStartTime;

  bool get isFinished => steps.isNotEmpty && currentStepIndex >= steps.length;
  
  RecipeStep? get currentStep =>
      (steps.isEmpty || isFinished) ? null : steps[currentStepIndex];

  String? get currentStepText => currentStep?.instruction;
  
  List<String> get currentStepTools =>
      currentStep?.items.map((i) => i.tag).toList() ?? [];

  List<String> get currentStepActions =>
      currentStep?.ingredients.expand((i) => i.actions).toSet().toList() ?? [];
  
  double get progress => steps.isEmpty ? 0.0 : currentStepIndex / steps.length;

  const GameState({
    this.recipeId = '',
    this.steps = const [],
    this.currentStepIndex = 0,
    this.isLoading = false,
    this.durationMinutes = 0,
    this.gameStartTime,
  });

  GameState copyWith({
    String? recipeId,
    List<RecipeStep>? steps,
    int? currentStepIndex,
    bool? isLoading,
    int? durationMinutes,
    DateTime? gameStartTime,
  }) {
    return GameState(
      recipeId: recipeId ?? this.recipeId,
      steps: steps ?? this.steps,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      isLoading: isLoading ?? this.isLoading,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      gameStartTime: gameStartTime ?? this.gameStartTime,
    );
  }
}
