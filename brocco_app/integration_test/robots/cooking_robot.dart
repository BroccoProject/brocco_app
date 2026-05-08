import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brocco_app/features/home/widgets/category_card.dart';
import 'package:brocco_app/features/roadmap/widgets/roadmap_node_tile.dart';

class CookingRobot {
  final WidgetTester tester;

  CookingRobot(this.tester);

  Future<void> tapFirstCategory() async {
    await tester.tap(find.byType(CategoryCard).first);
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> tapFirstRoadmapNode() async {
    await tester.tap(find.byType(RoadmapNodeTile).first);
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> tapIngredientsTab(String label) async {
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> tapRecipeTab(String label) async {
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> tapStartCooking() async {
    await tester.tap(find.byKey(const Key('recipe_detail_start_cooking')));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> tapAddIngredient({int times = 1}) async {
    for (int i = 0; i < times; i++) {
      await tester.tap(find.byKey(const Key('game_cooking_stage')));
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> tapNextOrFinish() async {
    await tester.tap(find.byKey(const Key('game_primary_action_button')));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> tapClaimRewards() async {
    await tester.tap(find.byKey(const Key('level_completed_claim_button')));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 1));
  }

  void assertNodeShowsDoneBadge(String nodeId) {
    expect(
      find.byKey(Key('roadmap_node_done_badge_$nodeId')),
      findsOneWidget,
    );
  }

  void assertStarCount(String count) {
    expect(find.text(count), findsOneWidget);
  }
}
