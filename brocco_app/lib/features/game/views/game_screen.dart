import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

class _GameScreenState extends ConsumerState<GameScreen>
    with TickerProviderStateMixin {
  int _addedIngredientsCount = 0;
  double _timerFill = 1.0;

  late AnimationController _fillAnimController;
  late Animation<double> _fillAnimation;
  double _previousFill = 0.0;

  @override
  void initState() {
    super.initState();
    _fillAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fillAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(parent: _fillAnimController, curve: Curves.easeOut),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(gameViewModelProvider.notifier)
          .startGame(widget.recipeId, widget.recipeText);
    });
  }

  @override
  void dispose() {
    _fillAnimController.dispose();
    super.dispose();
  }

  void _animateFill(double targetFill) {
    _fillAnimation = Tween<double>(
      begin: _previousFill,
      end: targetFill,
    ).animate(
      CurvedAnimation(parent: _fillAnimController, curve: Curves.easeOut),
    );
    _fillAnimController.forward(from: 0);
    _previousFill = targetFill;
  }

  void _addIngredient(int totalIngredients) {
    if (_addedIngredientsCount >= totalIngredients) return;
    setState(() => _addedIngredientsCount++);
    _animateFill(_addedIngredientsCount / totalIngredients);
  }

  void _resetIngredients() {
    setState(() {
      _addedIngredientsCount = 0;
      _previousFill = 0.0;
      _timerFill = 1.0;
    });
    _fillAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(parent: _fillAnimController, curve: Curves.easeOut),
    );
    _fillAnimController.reset();
  }

  void _onTimerTick(Duration remaining, Duration total) {
    final fraction = total.inSeconds > 0
        ? remaining.inSeconds / total.inSeconds
        : 0.0;
    setState(() => _timerFill = fraction);
  }

  void _finishGame() {
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

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameViewModelProvider);
    final stepText = gameState.currentStepText;
    final stepDuration = stepText != null ? parseStepDuration(stepText) : null;
    final stepNumber = gameState.currentStepIndex + 1;
    final totalSteps = gameState.steps.length;
    final isLastStep = gameState.steps.isNotEmpty &&
        gameState.currentStepIndex >= gameState.steps.length - 1;

    final currentStep = gameState.currentStep;
    final stepIngredients = currentStep?.ingredients ?? [];
    final totalIngredients = stepIngredients.length;

    final currentStepTools = gameState.currentStepTools.isNotEmpty
        ? gameState.currentStepTools
        : ['spoon'];

    final hasTimer = stepDuration != null;
    final hasIngredients = totalIngredients > 0;

    Animation<double> stageAnimation;
    if (hasIngredients) {
      stageAnimation = _fillAnimation;
    } else if (hasTimer) {
      stageAnimation = AlwaysStoppedAnimation(_timerFill);
    } else {
      stageAnimation = const AlwaysStoppedAnimation(1.0);
    }

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OnboardingBackButton(
                    onTap: () {
                      if (gameState.currentStepIndex > 0) {
                        ref.read(gameViewModelProvider.notifier).previousStep();
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
                      onTick: hasIngredients ? null : _onTimerTick,
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            GameInstructionBubble(
              stepNumber: stepNumber,
              stepText: stepText,
            ),

            const SizedBox(height: 16),

            Expanded(
              child: GameCookingStage(
                tools: currentStepTools,
                ingredients: stepIngredients,
                addedCount: _addedIngredientsCount,
                fillAnimation: stageAnimation,
                onTap: () => _addIngredient(totalIngredients),
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: PrimaryButton(
                text: isLastStep ? 'Zakończ' : 'Gotowe! Następny Krok',
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
