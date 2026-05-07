import 'package:flutter_test/flutter_test.dart';
import 'package:brocco_app/shared/models/recipe_difficulty.dart';

void main() {
  group('RecipeDifficulty.fromString', () {
    test('zwraca intermediate gdy value jest null', () {
      expect(RecipeDifficulty.fromString(null), RecipeDifficulty.intermediate);
    });

    test('rozpoznaje "begginner" (literówka z bazy) jako beginner', () {
      expect(RecipeDifficulty.fromString('Begginner'), RecipeDifficulty.beginner);
    });

    test('rozpoznaje "master chef" jako masterChef', () {
      expect(RecipeDifficulty.fromString('Master Chef'), RecipeDifficulty.masterChef);
    });

    test('rozpoznaje "master" jako masterChef', () {
      expect(RecipeDifficulty.fromString('master'), RecipeDifficulty.masterChef);
    });

    test('zwraca intermediate dla nieznanej wartości', () {
      expect(RecipeDifficulty.fromString('unknown'), RecipeDifficulty.intermediate);
    });

    test('zwraca intermediate dla pustego stringa', () {
      expect(RecipeDifficulty.fromString(''), RecipeDifficulty.intermediate);
    });
  });

  group('RecipeDifficulty właściwości', () {
    test('beginner ma score 1 i starCount 1', () {
      expect(RecipeDifficulty.beginner.score, 1);
      expect(RecipeDifficulty.beginner.starCount, 1);
    });

    test('intermediate ma score 2 i starCount 2', () {
      expect(RecipeDifficulty.intermediate.score, 2);
      expect(RecipeDifficulty.intermediate.starCount, 2);
    });

    test('masterChef ma score 3 i starCount 3', () {
      expect(RecipeDifficulty.masterChef.score, 3);
      expect(RecipeDifficulty.masterChef.starCount, 3);
    });

    test('dbValue zgadza się z wartością w bazie danych', () {
      expect(RecipeDifficulty.beginner.dbValue, 'Beginner');
      expect(RecipeDifficulty.intermediate.dbValue, 'Intermediate');
      expect(RecipeDifficulty.masterChef.dbValue, 'Master Chef');
    });
  });
}
