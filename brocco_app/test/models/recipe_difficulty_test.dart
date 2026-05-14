import 'package:flutter_test/flutter_test.dart';
import 'package:brocco_app/shared/models/recipe_difficulty.dart';

void main() {
  group('RecipeDifficulty.fromString', () {
    test('zwraca intermediate gdy value jest null', () {
      expect(RecipeDifficulty.fromString(null), RecipeDifficulty.intermediate);
    });
  });
}
