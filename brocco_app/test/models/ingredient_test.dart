import 'package:flutter_test/flutter_test.dart';
import 'package:brocco_app/shared/models/ingredient.dart';

void main() {
  group('Ingredient.formattedAmount', () {
    test('zwraca pusty string gdy amount i unit są null', () {
      const ingredient = Ingredient(id: '1', name: 'Sól', amount: null, unit: null);
      expect(ingredient.formattedAmount, '');
    });

    // Ważne: 200.0 powinno wyświetlić się jako "200 g", nie "200.0 g"
    test('formatuje liczbę całkowitą bez części dziesiętnej', () {
      const ingredient = Ingredient(id: '2', name: 'Mąka', amount: 200.0, unit: 'g');
      expect(ingredient.formattedAmount, '200 g');
    });

    // Gdy amount jest null ale unit jest podany — np. "szczypta"
    test('zwraca samo unit gdy amount jest null', () {
      const ingredient = Ingredient(id: '3', name: 'Pieprz', amount: null, unit: 'szczypta');
      expect(ingredient.formattedAmount, 'szczypta');
    });
  });
}
