import 'package:flutter_test/flutter_test.dart';
import 'package:brocco_app/features/roadmap/models/roadmap_data.dart';
import 'package:brocco_app/features/roadmap/models/roadmap_node.dart';
import 'package:brocco_app/features/home/models/category.dart';

Category _makeCategory() =>
    const Category(id: 'cat1', title: 'Dania główne', unlockCostStars: 0);

RoadmapNode _makeNode(String id, {List<String> prerequisites = const []}) {
  return RoadmapNode(
    id: id,
    categoryId: 'cat1',
    title: 'Krok $id',
    mapColumn: 0,
    mapRow: 0,
    prerequisiteIds: prerequisites,
  );
}

void main() {
  group('RoadmapData.isNodeCompleted', () {
    final data = RoadmapData(
      category: _makeCategory(),
      completedNodeIds: const {'node1', 'node2'},
    );

    test('zwraca true dla ukończonego węzła', () {
      expect(data.isNodeCompleted('node1'), isTrue);
    });

    test('zwraca false dla nieukończonego węzła', () {
      expect(data.isNodeCompleted('node3'), isFalse);
    });
  });

  group('RoadmapData.isNodeUnlocked', () {
    final data = RoadmapData(
      category: _makeCategory(),
      completedNodeIds: const {'node1'},
    );

    test('węzeł bez prerequisitów jest zawsze odblokowany', () {
      final node = _makeNode('nodeA');
      expect(data.isNodeUnlocked(node), isTrue);
    });

    test('węzeł z ukończonym prerequisitem jest odblokowany', () {
      final node = _makeNode('nodeB', prerequisites: ['node1']);
      expect(data.isNodeUnlocked(node), isTrue);
    });

    test('węzeł z nieukończonym prerequisitem jest zablokowany', () {
      final node = _makeNode('nodeC', prerequisites: ['node2']);
      expect(data.isNodeUnlocked(node), isFalse);
    });

    test('węzeł z wieloma prerequisitami odblokowany gdy wszystkie ukończone', () {
      final dataMulti = RoadmapData(
        category: _makeCategory(),
        completedNodeIds: const {'node1', 'node2'},
      );
      final node = _makeNode('nodeD', prerequisites: ['node1', 'node2']);
      expect(dataMulti.isNodeUnlocked(node), isTrue);
    });

    test('węzeł z wieloma prerequisitami zablokowany gdy jeden nie ukończony', () {
      final node = _makeNode('nodeE', prerequisites: ['node1', 'node99']);
      expect(data.isNodeUnlocked(node), isFalse);
    });
  });

  group('RoadmapData.isEmpty', () {
    test('zwraca true gdy nodes jest puste', () {
      final data = RoadmapData(category: _makeCategory());
      expect(data.isEmpty, isTrue);
    });

    test('zwraca false gdy nodes ma elementy', () {
      final data = RoadmapData(
        category: _makeCategory(),
        nodes: [_makeNode('n1')],
      );
      expect(data.isEmpty, isFalse);
    });
  });
}
