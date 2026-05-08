import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:brocco_app/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/buttons/main_back_text_button.dart';
import '../../../shared/widgets/buttons/main_progress_bar.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../../../shared/widgets/step_timer.dart';
import '../utils/step_time_parser.dart';
import '../viewmodels/game_viewmodel.dart';
import 'widgets/game_cooking_stage.dart';
import 'widgets/game_instruction_bubble.dart';

class GameScreen extends ConsumerStatefulWidget {
  final String recipeId;
  final String recipeText;
  final String nodeId;
  final String categoryId;
  final String recipeTitle;

  const GameScreen({
    super.key,
    required this.recipeId,
    required this.recipeText,
    required this.nodeId,
    required this.categoryId,
    required this.recipeTitle,
  });

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  int _addedIngredientsCount = 0;
  double _timerFill = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameViewModelProvider.notifier).resetGame();
      ref
          .read(gameViewModelProvider.notifier)
          .startGame(widget.recipeId, widget.recipeText);
    });
  }

  void _addIngredient(int totalIngredients) {
    if (_addedIngredientsCount >= totalIngredients) return;
    setState(() => _addedIngredientsCount++);
  }

  void _resetIngredients() {
    setState(() {
      _addedIngredientsCount = 0;
      _timerFill = 1.0;
    });
  }

  void _onTimerTick(Duration remaining, Duration total) {
    final fraction = total.inSeconds > 0
        ? remaining.inSeconds / total.inSeconds
        : 0.0;
    setState(() => _timerFill = fraction);
  }

  void _finishGame() {
    final gameState = ref.read(gameViewModelProvider);
    final startTime = gameState.gameStartTime;
    final durationMinutes = gameState.durationMinutes;

    bool isTooFast = false;
    if (startTime != null && durationMinutes > 0) {
      final elapsedSeconds = DateTime.now().difference(startTime).inSeconds;
      final thresholdSeconds = (durationMinutes * 60) * 0.01;
      if (elapsedSeconds < thresholdSeconds) {
        isTooFast = true;
      }
    }

    if (isTooFast) {
      context.pushReplacement(
        Uri(
          path: '/game/too_fast',
          queryParameters: {
            'recipeId': widget.recipeId,
            'recipeText': widget.recipeText,
            'nodeId': widget.nodeId,
            'categoryId': widget.categoryId,
            'recipeTitle': widget.recipeTitle,
          },
        ).toString(),
      );
    } else {
      context.pushReplacement(
        Uri(
          path: '/game/completed',
          queryParameters: {
            'nodeId': widget.nodeId,
            'categoryId': widget.categoryId,
            'recipeTitle': widget.recipeTitle,
          },
        ).toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameViewModelProvider);

    // Show a loading screen while data is being fetched or state has been reset.
    if (gameState.isLoading || gameState.steps.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.accentGreen),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.processingRecipe,
                style: const TextStyle(
                  color: AppColors.greyText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final stepText = gameState.currentStepText;
    final stepDuration = stepText != null ? parseStepDuration(stepText) : null;
    final stepNumber = gameState.currentStepIndex + 1;
    final totalSteps = gameState.steps.length;
    final isLastStep =
        gameState.steps.isNotEmpty &&
        gameState.currentStepIndex >= gameState.steps.length - 1;

    final currentStep = gameState.currentStep;
    final stepIngredients = currentStep?.ingredients ?? [];
    final totalIngredients = stepIngredients.length;

    final currentStepTools = gameState.currentStepTools.isNotEmpty
        ? gameState.currentStepTools
        : ['spoon'];

    final hasIngredients = totalIngredients > 0;
    final hasTimer = stepDuration != null;

    final bool allIngredientsAdded =
        !hasIngredients || _addedIngredientsCount >= totalIngredients;

    final double ingredientFillFraction = hasIngredients
        ? _addedIngredientsCount / totalIngredients
        : 1.0;

    final double timerElapsedFraction = hasTimer && allIngredientsAdded
        ? (1.0 - _timerFill)
        : 0.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: MainProgressBar(
                currentStep: gameState.steps.isEmpty ? 0 : stepNumber,
                totalSteps: totalSteps,
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OnboardingBackButton(
                      onTap: () {
                        if (gameState.currentStepIndex > 0) {
                          ref
                              .read(gameViewModelProvider.notifier)
                              .previousStep();
                          _resetIngredients();
                        } else {
                          context.pop();
                        }
                      },
                    ),
                    if (hasTimer)
                      StepTimer(
                        key: ValueKey(gameState.currentStepIndex),
                        duration: stepDuration,
                        isEnabled: allIngredientsAdded,
                        onTick: _onTimerTick,
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            GameInstructionBubble(stepNumber: stepNumber, stepText: stepText),

            const SizedBox(height: 16),

            Expanded(
              child: GameCookingStage(
                key: const Key('game_cooking_stage'),
                tools: currentStepTools,
                ingredients: stepIngredients,
                addedCount: _addedIngredientsCount,
                ingredientFillFraction: ingredientFillFraction,
                timerFillFraction: timerElapsedFraction,
                hasTimer: hasTimer,
                onTap: () => _addIngredient(totalIngredients),
                stepIndex: gameState.currentStepIndex,
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: PrimaryButton(
                key: const Key('game_primary_action_button'),
                text: isLastStep
                    ? AppLocalizations.of(context)!.finish
                    : AppLocalizations.of(context)!.nextStep,
                onPressed: () {
                  if (isLastStep) {
                    _finishGame();
                  } else {
                    ref.read(gameViewModelProvider.notifier).nextStep();
                    _resetIngredients();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
