import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:brocco_app/core/theme/app_colors.dart';
import 'package:brocco_app/shared/models/recipe.dart';
import 'package:brocco_app/features/roadmap/models/roadmap_node.dart';
import 'package:brocco_app/features/home/models/category.dart';
import 'package:brocco_app/features/roadmap/models/roadmap_data.dart';
import 'package:brocco_app/features/recipe_detail/views/recipe_detail_screen.dart';
import 'package:brocco_app/features/game/views/game_screen.dart';
import 'package:brocco_app/features/roadmap/views/roadmap_screen.dart';
import 'package:brocco_app/features/browser/views/browser_screen.dart';
import 'package:brocco_app/shared/models/recipe_step.dart';
import 'package:brocco_app/l10n/generated/app_localizations.dart';
import 'package:brocco_app/features/home/views/main_screen.dart';

import 'package:brocco_app/shared/repositories/recipe_repository.dart';
import 'package:brocco_app/features/roadmap/repositories/roadmap_repository.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:brocco_app/core/local_db/global_sync_service.dart';
import 'package:brocco_app/features/auth/repositories/auth_repository.dart';
import 'package:brocco_app/features/auth/viewmodels/auth_viewmodel.dart' as vm;
import 'package:brocco_app/features/browser/repositories/browser_repository.dart';

import 'robots/cooking_robot.dart';
import 'robots/browser_robot.dart';
import 'mocks/mock_isar.dart';
import 'package:brocco_app/core/local_db/isar_provider.dart';
import 'mocks/mock_recipe_repository.dart';
import 'mocks/mock_roadmap_repository.dart';
import 'mocks/mock_browser_repository.dart';
import 'mocks/mock_auth_repository.dart';
import 'mocks/mock_global_sync_service.dart';
import 'mocks/mock_home_repository.dart';
import 'package:brocco_app/features/home/repositories/home_repository.dart';
import 'package:brocco_app/features/home/models/home_data.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    binding.renderView.configuration = TestViewConfiguration.fromView(
      view: binding.platformDispatcher.views.first,
      size: const Size(1080, 2400),
    );
  });

  runFullGameFlowTests(binding);
  runBrowserTests();
}

const _testCategoryId = 'cat-eggs-101';

final _roadmapCategory = Category(
  id: _testCategoryId,
  title: 'Egg Basics',
  imageUrl: 'https://example.com/eggs.jpg',
);

final _scrambledEggsNode = RoadmapNode(
  id: 'node-scrambled-eggs',
  categoryId: _testCategoryId,
  title: 'Basic Scrambled Eggs',
  recipeId: 'recipe-001',
  mapRow: 0,
  mapColumn: 0,
);

final _scrambledEggsRecipe = Recipe(
  id: 'recipe-001',
  title: 'Basic Scrambled Eggs',
  description: 'Fluffy scrambled eggs.',
  steps: [
    RecipeStep(
      id: 'step-1',
      stepNumber: 1,
      instruction: 'Crack 2 eggs into a bowl.',
    ),
    RecipeStep(id: 'step-2', stepNumber: 2, instruction: 'Whisk thoroughly.'),
    RecipeStep(
      id: 'step-3',
      stepNumber: 3,
      instruction: 'Cook on low heat until set.',
    ),
  ],
  durationMinutes: 5,
  difficultyLevel: 'Easy',
  tags: ['High Protein', 'Breakfast'],
);

final _highProteinRecipe = Recipe(
  id: 'recipe-002',
  title: 'High Protein Chicken Bowl',
  description: 'A healthy protein bowl.',
  durationMinutes: 10,
  difficultyLevel: 'Medium',
  tags: ['High Protein', 'Lunch'],
  steps: [],
);

final _slowCookRecipe = Recipe(
  id: 'recipe-003',
  title: 'Slow Roasted Beef',
  description: 'Tender beef roast.',
  durationMinutes: 240,
  difficultyLevel: 'Hard',
  tags: ['Dinner'],
  steps: [],
);

ThemeData _testTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryOrange),
  );
}

const _kLocalizationDelegates = AppLocalizations.localizationsDelegates;

void runFullGameFlowTests(IntegrationTestWidgetsFlutterBinding binding) {
  group('Scenario 1 – Full Game Flow (Home -> Roadmap -> Recipe -> Game)', () {
    late MockHomeRepository mockHomeRepo;
    late MockRoadmapRepository mockRoadmapRepo;
    late MockRecipeRepository mockRecipeRepo;
    late MockAuthRepository mockAuthRepo;
    late MockGlobalSyncService mockSyncService;

    setUp(() {
      mockHomeRepo = MockHomeRepository.withData(
        data: HomeData(
          categories: [_roadmapCategory],
          currentStars: 0,
          unlockedIds: {_testCategoryId},
          completedMeals: {_testCategoryId: 0},
          totalMeals: {_testCategoryId: 1},
        ),
      );

      mockRoadmapRepo = MockRoadmapRepository.withData(
        localData: RoadmapData(
          category: _roadmapCategory,
          nodes: [_scrambledEggsNode],
          completedNodeIds: const {},
          currentStars: 0,
          completedCount: 0,
          totalCount: 1,
        ),
      );

      mockRecipeRepo = MockRecipeRepository.withRecipe(
        recipe: _scrambledEggsRecipe,
      );

      mockAuthRepo = MockAuthRepository();
      mockSyncService = MockGlobalSyncService();

      final user = User(
        id: 'test-user-id',
        appMetadata: {},
        userMetadata: {},
        aud: 'aud',
        createdAt: DateTime.now().toIso8601String(),
      );
      final session = Session(
        accessToken: 'token',
        tokenType: 'bearer',
        user: user,
      );

      when(() => mockAuthRepo.onAuthStateChange).thenAnswer(
        (_) => Stream.value(AuthState(AuthChangeEvent.signedIn, session)),
      );
      when(() => mockAuthRepo.currentSession).thenReturn(session);
    });

    testWidgets('User navigates from Home to Game and finishes', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            homeRepositoryProvider.overrideWithValue(mockHomeRepo),
            roadmapRepositoryProvider.overrideWithValue(mockRoadmapRepo),
            recipeRepositoryProvider.overrideWithValue(mockRecipeRepo),
            authRepositoryProvider.overrideWithValue(mockAuthRepo),
            globalSyncServiceProvider.overrideWithValue(mockSyncService),
            isarProvider.overrideWithValue(MockIsar()),
            vm.authViewModelProvider.overrideWith(
              () => vm.AuthViewModel()
                ..state = AsyncData(
                  vm.AuthState(
                    status: vm.AuthStatus.authenticated,
                    hasProfile: true,
                  ),
                ),
            ),
          ],
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const MainScreen(),
                ),
                GoRoute(
                  path: '/roadmap/:categoryId',
                  builder: (context, state) => RoadmapScreen(
                    categoryId: state.pathParameters['categoryId']!,
                  ),
                ),
                GoRoute(
                  path: '/recipe/:recipeId',
                  builder: (context, state) => RecipeDetailScreen(
                    recipeId: state.pathParameters['recipeId']!,
                    nodeId: state.uri.queryParameters['nodeId'],
                    categoryId: state.uri.queryParameters['categoryId'],
                    recipeTitle: state.uri.queryParameters['recipeTitle'],
                  ),
                ),
                GoRoute(
                  path: '/game/play',
                  builder: (context, state) => GameScreen(
                    recipeId: state.uri.queryParameters['recipeId'] ?? '',
                    recipeText: state.uri.queryParameters['recipeText'] ?? '',
                    nodeId: state.uri.queryParameters['nodeId'] ?? '',
                    categoryId: state.uri.queryParameters['categoryId'] ?? '',
                    recipeTitle: state.uri.queryParameters['recipeTitle'] ?? '',
                  ),
                ),
                GoRoute(
                  path: '/game/completed',
                  builder: (context, state) => Scaffold(
                    key: const Key('level_completed_screen'),
                    body: ElevatedButton(
                      key: const Key('level_completed_claim_button'),
                      onPressed: () => context.go('/'),
                      child: const Text('Finish'),
                    ),
                  ),
                ),
              ],
            ),
            localizationsDelegates: _kLocalizationDelegates,
            supportedLocales: const [Locale('en')],
            locale: const Locale('en'),
            theme: _testTheme(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final robot = CookingRobot(tester);

      await robot.tapFirstCategory();
      await robot.tapFirstRoadmapNode();
      await robot.tapIngredientsTab('Ingredients');
      await robot.tapRecipeTab('Recipe');
      await robot.tapStartCooking();
      await robot.tapAddIngredient(times: 1);
      await robot.tapNextOrFinish();
      await robot.tapAddIngredient(times: 1);
      await robot.tapNextOrFinish();

      await binding.traceAction(() async {
        await robot.tapNextOrFinish(withDelay: false);
      }, reportKey: 'my_performance_report');

      await robot.tapClaimRewards();

      expect(find.byType(MainScreen), findsOneWidget);
    });
  });
}

void runBrowserTests() {
  group('Scenario 2 – Discovery Engine (Search & Filter)', () {
    late MockRecipeRepository mockRecipeRepo;
    late MockBrowserRepository mockBrowserRepo;

    setUp(() {
      mockRecipeRepo = MockRecipeRepository.withRecipe(
        recipe: _highProteinRecipe,
      );
      mockBrowserRepo = MockBrowserRepository.withRecipes(
        recipes: [_highProteinRecipe, _slowCookRecipe],
      );
    });

    testWidgets(
      'User filters by max 15 min, taps the first result, sees High Protein tag',
      (tester) async {
        final router = GoRouter(
          initialLocation: '/browser',
          routes: [
            GoRoute(
              path: '/browser',
              builder: (context, state) => const BrowserScreen(),
            ),
            GoRoute(
              path: '/recipe/:recipeId',
              builder: (context, state) {
                return RecipeDetailScreen(
                  recipeId: state.pathParameters['recipeId']!,
                );
              },
            ),
          ],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              browserRepositoryProvider.overrideWithValue(mockBrowserRepo),
              recipeRepositoryProvider.overrideWithValue(mockRecipeRepo),
            ],
            child: MaterialApp.router(
              routerConfig: router,
              localizationsDelegates: _kLocalizationDelegates,
              supportedLocales: const [Locale('en')],
              locale: const Locale('en'),
              theme: _testTheme(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final browserRobot = BrowserRobot(tester);

        await browserRobot.tapFilterButton();
        await browserRobot.tapApplyFilters();
        await browserRobot.tapFirstRecipeCard();
        browserRobot.assertTagVisible('High Protein');
      },
    );
  });
}
