import 'package:flutter_test/flutter_test.dart';
import 'package:brocco_app/features/home/models/home_data.dart';
import 'package:brocco_app/features/home/models/category.dart';

void main() {
  group('HomeData.isCategoryLocked', () {
    test('kategoria darmowa nie jest zablokowana', () {
      const data = HomeData(unlockedIds: {});
      const freeCategory = Category(id: 'c1', title: 'Free', unlockCostStars: 0);
      expect(data.isCategoryLocked(freeCategory), isFalse);
    });

    test('kategoria płatna jest zablokowana gdy nie odblokowana', () {
      const data = HomeData(unlockedIds: {});
      const paidCategory = Category(id: 'c2', title: 'Premium', unlockCostStars: 50);
      expect(data.isCategoryLocked(paidCategory), isTrue);
    });

    test('kategoria płatna jest odblokowana gdy id jest w unlockedIds', () {
      const data = HomeData(unlockedIds: {'c2'});
      const paidCategory = Category(id: 'c2', title: 'Premium', unlockCostStars: 50);
      expect(data.isCategoryLocked(paidCategory), isFalse);
    });
  });

  group('HomeData.completedFor i totalFor', () {
    const data = HomeData(
      completedMeals: {'c1': 3, 'c2': 7},
      totalMeals: {'c1': 10},
    );

    test('completedFor zwraca prawidłową liczbę ukończonych posiłków', () {
      expect(data.completedFor('c1'), 3);
      expect(data.completedFor('c2'), 7);
    });

    test('completedFor zwraca 0 dla nieznanej kategorii', () {
      expect(data.completedFor('unknown'), 0);
    });

    test('totalFor zwraca prawidłową liczbę posiłków', () {
      expect(data.totalFor('c1'), 10);
    });

    test('totalFor zwraca 0 dla nieznanej kategorii', () {
      expect(data.totalFor('unknown'), 0);
    });
  });

  group('HomeData.copyWith', () {
    const original = HomeData(currentStars: 10, completedMeals: {'c1': 2});

    test('copyWith aktualizuje currentStars', () {
      final updated = original.copyWith(currentStars: 25);
      expect(updated.currentStars, 25);
      expect(updated.completedMeals, {'c1': 2});
    });

    test('copyWith nie zmienia pól których nie podano', () {
      final updated = original.copyWith(totalMeals: {'c1': 5});
      expect(updated.currentStars, 10);
      expect(updated.totalMeals, {'c1': 5});
    });
  });

  group('Category.isLocked', () {
    test('isLocked jest true gdy unlockCostStars > 0', () {
      const cat = Category(id: 'x', title: 'X', unlockCostStars: 100);
      expect(cat.isLocked, isTrue);
    });

    test('isLocked jest false gdy unlockCostStars == 0', () {
      const cat = Category(id: 'y', title: 'Y', unlockCostStars: 0);
      expect(cat.isLocked, isFalse);
    });
  });
}
