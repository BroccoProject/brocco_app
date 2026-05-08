import 'package:flutter_test/flutter_test.dart';
import 'package:brocco_app/shared/repositories/dtos/ingredient_dto.dart';
import 'package:brocco_app/shared/repositories/dtos/item_dto.dart';
import 'package:brocco_app/shared/repositories/dtos/recipe_dto.dart';

void main() {
  group('IngredientDto.fromJson – nested Supabase join', () {
    // Supabase zwraca składnik zagnieżdżony pod kluczem "ingredients"
    // — dane id/name trzeba wyciągnąć z podjointu, a amount/unit z rodzica
    test('wyciąga id i name z zagnieżdżonego pola "ingredients"', () {
      final json = {
        'amount': 200.0,
        'unit': 'g',
        'sort_order': 1,
        'ingredients': {
          'id': 'ing-1',
          'name': 'Mąka pszenna',
          'name_i18n': <String, dynamic>{},
        },
      };
      final dto = IngredientDto.fromJson(json);
      expect(dto.id, 'ing-1');
      expect(dto.name, 'Mąka pszenna');
      expect(dto.amount, 200.0);
      expect(dto.unit, 'g');
    });
  });

  group('ItemDto.fromJson – nested join z fallbackiem', () {
    // Gdy brak zagnieżdżonego "items", powinien użyć pól bezpośrednich
    test('fallback na płaskie pola gdy brak zagnieżdżonego "items"', () {
      final json = {
        'id': 'item-flat',
        'name': 'Patelnia',
        'name_i18n': <String, dynamic>{},
        'tag': 'pan',
      };
      final dto = ItemDto.fromJson(json);
      expect(dto.id, 'item-flat');
      expect(dto.tag, 'pan');
    });
  });

  group('RecipeDto.fromJson – bezpieczne null handling', () {
    // Gdy Supabase nie zwróci kroków, lista powinna być pusta — nie null
    test('zwraca puste listy steps i ingredients gdy pola są null', () {
      final json = {
        'id': 'r1',
        'title': 'Zupa',
        'title_i18n': null,
        'description_i18n': null,
        'recipe_steps': null,
        'recipe_ingredients': null,
      };
      final dto = RecipeDto.fromJson(json);
      expect(dto.steps, isEmpty);
      expect(dto.recipeIngredients, isEmpty);
    });
  });
}
