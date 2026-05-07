import 'package:flutter_test/flutter_test.dart';
import 'package:brocco_app/shared/models/ingredient.dart';

void main() {
  group('Ingredient.formattedAmount', () {
    test('zwraca pusty string gdy amount i unit są null', () {
      const ingredient = Ingredient(
        id: '1',
        name: 'Sól',
        amount: null,
        unit: null,
      );
      expect(ingredient.formattedAmount, '');
    });

    test('zwraca całkowitą liczbę bez ułamka gdy amount jest liczbą całkowitą', () {
      const ingredient = Ingredient(
        id: '2',
        name: 'Mąka',
        amount: 200.0,
        unit: 'g',
      );
      expect(ingredient.formattedAmount, '200 g');
    });

    test('zwraca liczbę dziesiętną gdy amount ma część ułamkową', () {
      const ingredient = Ingredient(
        id: '3',
        name: 'Olej',
        amount: 0.5,
        unit: 'l',
      );
      expect(ingredient.formattedAmount, '0.5 l');
    });

    test('zwraca tylko amount gdy unit jest null', () {
      const ingredient = Ingredient(
        id: '4',
        name: 'Jajka',
        amount: 3.0,
        unit: null,
      );
      expect(ingredient.formattedAmount, '3');
    });

    test('zwraca tylko unit gdy amount jest null', () {
      const ingredient = Ingredient(
        id: '5',
        name: 'Cukier',
        amount: null,
        unit: 'szczypta',
      );
      expect(ingredient.formattedAmount, 'szczypta');
    });
  });
}
