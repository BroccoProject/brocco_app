import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class BrowserRobot {
  final WidgetTester tester;

  BrowserRobot(this.tester);

  Future<void> tapFilterButton() async {
    await tester.tap(find.byKey(const Key('browser_filter_button')));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> dragTimeSliderTo(int minutes) async {
    final sliderFinder = find.byKey(const Key('filter_time_slider'));
    expect(sliderFinder, findsOneWidget);

    const double sliderMin = 5.0;
    const double sliderMax = 120.0;
    final fraction = (minutes - sliderMin) / (sliderMax - sliderMin);

    final RenderBox box =
        tester.renderObject(sliderFinder) as RenderBox;
    final Offset topLeft = box.localToGlobal(Offset.zero);
    final double sliderWidth = box.size.width;
    final double centerY = box.size.height / 2;

    await tester.tapAt(topLeft + Offset(sliderWidth * fraction, centerY));
    await tester.pump();
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> tapApplyFilters() async {
    await tester.tap(find.byKey(const Key('filter_apply_button')));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> tapFirstRecipeCard() async {
    await tester.tap(find.byKey(const Key('recipe_browser_card')).first);
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 1));
  }

  void assertTagVisible(String text) {
    expect(find.text(text), findsOneWidget);
  }
}
