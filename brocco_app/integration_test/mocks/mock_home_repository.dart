import 'package:mocktail/mocktail.dart';
import 'package:brocco_app/features/home/repositories/home_repository.dart';
import 'package:brocco_app/features/home/models/home_data.dart';

class MockHomeRepository extends Mock implements HomeRepository {
  MockHomeRepository();

  factory MockHomeRepository.withData({
    required HomeData data,
  }) {
    final mock = MockHomeRepository();

    when(
      () => mock.getHomeDataFromLocal(any()),
    ).thenAnswer((_) async => data);

    when(
      () => mock.syncAndGetHomeData(any()),
    ).thenAnswer((_) async => data);

    return mock;
  }
}
