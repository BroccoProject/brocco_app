import 'package:flutter_test/flutter_test.dart';
import 'package:brocco_app/shared/repositories/dtos/recipe_dto.dart';
import 'package:brocco_app/shared/repositories/dtos/recipe_step_dto.dart';
import 'package:brocco_app/shared/repositories/dtos/ingredient_dto.dart';
import 'package:brocco_app/shared/repositories/dtos/item_dto.dart';

void main() {
  group('RecipeDto.fromJson', () {
    test('parsuje podstawowe pola przepisu', () {
      final json = {
        'id': 'recipe-1',
        'title': 'Spaghetti Bolognese',
        'title_i18n': {'pl': 'Spaghetti Bolognese'},
        'description': 'Klasyczny włoski przepis',
        'description_i18n': <String, dynamic>{},
        'image_url': 'https://example.com/img.jpg',
        'difficulty_level': 'Intermediate',
        'duration_minutes': 45,
        'youtube_url': null,
        'tags': ['pasta', 'italian'],
        'category': 'Obiady',
        'area': 'Italy',
        'source_url': null,
        'recipe_steps': <dynamic>[],
        'recipe_ingredients': <dynamic>[],
      };

      final dto = RecipeDto.fromJson(json);

      expect(dto.id, 'recipe-1');
      expect(dto.title, 'Spaghetti Bolognese');
      expect(dto.durationMinutes, 45);
      expect(dto.tags, containsAll(['pasta', 'italian']));
      expect(dto.steps, isEmpty);
      expect(dto.recipeIngredients, isEmpty);
    });

    test('zwraca puste listy gdy recipe_steps i recipe_ingredients są null', () {
      final json = {
        'id': 'recipe-2',
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

  group('RecipeStepDto.fromJson', () {
    test('parsuje krok przepisu z ingredientami i itemami', () {
      final json = {
        'id': 'step-1',
        'step_number': 1,
        'instruction': 'Ugotuj makaron',
        'instruction_i18n': <String, dynamic>{},
        'duration_seconds': 600,
        'step_ingredients': <dynamic>[],
        'step_items': <dynamic>[],
      };

      final dto = RecipeStepDto.fromJson(json);
      expect(dto.id, 'step-1');
      expect(dto.stepNumber, 1);
      expect(dto.instruction, 'Ugotuj makaron');
      expect(dto.durationSeconds, 600);
      expect(dto.ingredients, isEmpty);
      expect(dto.items, isEmpty);
    });
  });

  group('IngredientDto.fromJson', () {
    test('parsuje składnik z zagnieżdżonym polem ingredients', () {
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

    test('parsuje składnik bez zagnieżdżonego pola ingredients', () {
      final json = {
        'id': 'ing-2',
        'name': 'Sól',
        'name_i18n': <String, dynamic>{},
        'amount': null,
        'unit': null,
        'sort_order': 0,
      };

      final dto = IngredientDto.fromJson(json);
      expect(dto.id, 'ing-2');
      expect(dto.name, 'Sól');
      expect(dto.amount, isNull);
    });
  });

  group('ItemDto.fromJson', () {
    test('parsuje item z zagnieżdżonym polem items', () {
      final json = {
        'items': {
          'id': 'item-1',
          'name': 'Nóż',
          'name_i18n': <String, dynamic>{},
          'tag': 'knife',
        },
      };

      final dto = ItemDto.fromJson(json);
      expect(dto.id, 'item-1');
      expect(dto.name, 'Nóż');
      expect(dto.tag, 'knife');
    });

    test('parsuje item bez zagnieżdżonego pola items', () {
      final json = {
        'id': 'item-2',
        'name': 'Patelnia',
        'name_i18n': <String, dynamic>{},
        'tag': 'pan',
      };

      final dto = ItemDto.fromJson(json);
      expect(dto.id, 'item-2');
      expect(dto.tag, 'pan');
    });
  });
}
