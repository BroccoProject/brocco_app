import 'package:mocktail/mocktail.dart';
import 'package:brocco_app/features/roadmap/repositories/roadmap_repository.dart';
import 'package:brocco_app/features/roadmap/models/roadmap_data.dart';

class MockRoadmapRepository extends Mock implements RoadmapRepository {
  MockRoadmapRepository();
  factory MockRoadmapRepository.withData({
    required RoadmapData localData,
    RoadmapData? syncedData,
  }) {
    final mock = MockRoadmapRepository();

    when(
      () => mock.getRoadmapDataFromLocal(any(), any()),
    ).thenAnswer((_) async => localData);

    when(
      () => mock.syncAndGetRoadmapData(any(), any()),
    ).thenAnswer((_) async => syncedData ?? localData);

    return mock;
  }
}
