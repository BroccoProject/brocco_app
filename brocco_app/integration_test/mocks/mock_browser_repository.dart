import 'package:mocktail/mocktail.dart';
import 'package:brocco_app/features/browser/repositories/browser_repository.dart';
import 'package:brocco_app/shared/models/recipe.dart';

class MockBrowserRepository extends Mock implements BrowserRepository {
  MockBrowserRepository();

  factory MockBrowserRepository.withRecipes({required List<Recipe> recipes}) {
    final mock = MockBrowserRepository();
    when(() => mock.getRecipes()).thenAnswer((_) async => recipes);
    return mock;
  }
}
