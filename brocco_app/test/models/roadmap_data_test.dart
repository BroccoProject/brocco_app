import 'package:flutter_test/flutter_test.dart';
import 'package:brocco_app/features/roadmap/models/roadmap_data.dart';
import 'package:brocco_app/features/roadmap/models/roadmap_node.dart';
import 'package:brocco_app/features/home/models/category.dart';
import 'package:brocco_app/features/home/models/home_data.dart';

const _category = Category(id: 'cat', title: 'Test');

RoadmapNode _node(String id, {List<String> prereqs = const []}) => RoadmapNode(
  id: id,
  categoryId: 'cat',
  title: id,
  mapColumn: 0,
  mapRow: 0,
  prerequisiteIds: prereqs,
);

void main() {
  group('RoadmapData.isNodeUnlocked - logika prerequisitów', () {
    test('węzeł jest zablokowany gdy choć jeden prerequisit nie ukończony', () {
      final data = RoadmapData(
        category: _category,
        completedNodeIds: const {'node1'},
      );
      final node = _node('target', prereqs: ['node1', 'node2']);
      expect(data.isNodeUnlocked(node), isFalse);
    });

    test('węzeł odblokowany gdy wszystkie prerequisity ukończone', () {
      final data = RoadmapData(
        category: _category,
        completedNodeIds: const {'node1', 'node2'},
      );
      final node = _node('target', prereqs: ['node1', 'node2']);
      expect(data.isNodeUnlocked(node), isTrue);
    });
  });

  group('HomeData - blokowanie kategorii', () {
    test(
      'kategoria płatna pozostaje zablokowana bez odpowiedniego id w unlockedIds',
      () {
        const data = HomeData(unlockedIds: {'inne-id'});
        const cat = Category(
          id: 'premium',
          title: 'Premium',
          unlockCostStars: 100,
        );
        expect(data.isCategoryLocked(cat), isTrue);
      },
    );
  });
}
