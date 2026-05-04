import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/buttons/main_back_button.dart';
import '../../../shared/widgets/buttons/main_progress_bar.dart';
import '../../../shared/widgets/pills/stars_pill.dart';
import '../models/roadmap_data.dart';
import '../viewmodels/roadmap_viewmodel.dart';
import '../widgets/connector_line.dart';
import '../widgets/roadmap_node_tile.dart';

class RoadmapScreen extends ConsumerWidget {
  final String categoryId;

  const RoadmapScreen({super.key, required this.categoryId});

  static const double _nodeWidth = 140;
  static const double _nodeHeight = 164;
  static const double _columnGap = 110;
  static const double _rowGap = 24;
  static const double _padding = 28;

  double _nodeX(int col) => _padding + col * (_nodeWidth + _columnGap);
  double _nodeY(int row) => row * (_nodeHeight + _rowGap);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roadmapAsync = ref.watch(roadmapViewModelProvider(categoryId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: roadmapAsync.when(
          data: (state) {
            if (state.isEmpty) return _buildEmpty(context, state);
            return _buildContent(context, state, ref);
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primaryOrange),
          ),
          error: (err, _) => Center(
            child: Text('Błąd: $err',
                style: const TextStyle(color: Colors.redAccent)),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context, RoadmapData state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Row(
            children: [
              MainBackButton(onPressed: () => context.go('/')),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  state.category.title,
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Kategoria pusta',
              style: TextStyle(
                color: AppColors.greyText,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    RoadmapData state,
    WidgetRef ref,
  ) {
    int maxCol = 0;
    int globalMaxRow = 0;
    final minRowByCol = <int, int>{};
    final maxRowByCol = <int, int>{};

    for (final node in state.nodes) {
      if (node.mapColumn > maxCol) maxCol = node.mapColumn;
      if (node.mapRow > globalMaxRow) globalMaxRow = node.mapRow;

      final currentMin = minRowByCol[node.mapColumn];
      if (currentMin == null || node.mapRow < currentMin) {
        minRowByCol[node.mapColumn] = node.mapRow;
      }
      final currentMax = maxRowByCol[node.mapColumn];
      if (currentMax == null || node.mapRow > currentMax) {
        maxRowByCol[node.mapColumn] = node.mapRow;
      }
    }

    final canvasWidth =
        _padding * 2 + (maxCol + 1) * _nodeWidth + maxCol * _columnGap;
    final canvasHeight = (globalMaxRow + 1) * _nodeHeight + globalMaxRow * _rowGap;

    double getColOffsetY(int c) {
      if (!minRowByCol.containsKey(c)) return 0;
      final minR = minRowByCol[c]!;
      final maxR = maxRowByCol[c]!;
      final colHeight =
          (maxR - minR + 1) * _nodeHeight + (maxR - minR) * _rowGap;
      return (canvasHeight - colHeight) / 2 - _nodeY(minR);
    }

    final nodeById = {for (final n in state.nodes) n.id: n};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Row(
            children: [
              MainBackButton(onPressed: () => context.go('/')),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  state.category.title,
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              StarsPill(initialCount: state.currentStars),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 4),
          child: MainProgressBar(
            currentStep: state.completedCount,
            totalSteps: state.totalCount,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Przesuwaj, by odkrywać →',
            style: TextStyle(color: AppColors.greyText, fontSize: 13),
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                width: canvasWidth,
                height: canvasHeight + 24,
                child: Stack(
                  children: [
                    ...state.nodes.expand((node) {
                      return node.prerequisiteIds
                          .where((pid) => nodeById.containsKey(pid))
                          .map((pid) {
                        final from = nodeById[pid]!;
                        return ConnectorLine(
                          fromX: _nodeX(from.mapColumn) + _nodeWidth,
                          fromY: _nodeY(from.mapRow) +
                              getColOffsetY(from.mapColumn) +
                              _nodeHeight / 2,
                          toX: _nodeX(node.mapColumn),
                          toY: _nodeY(node.mapRow) +
                              getColOffsetY(node.mapColumn) +
                              _nodeHeight / 2,
                          isCompleted: state.isNodeCompleted(from.id) &&
                              state.isNodeCompleted(node.id),
                        );
                      });
                    }),
                    ...state.nodes.map((node) {
                      return Positioned(
                        left: _nodeX(node.mapColumn),
                        top: _nodeY(node.mapRow) + getColOffsetY(node.mapColumn),
                        child: RoadmapNodeTile(
                          node: node,
                          isCompleted: state.isNodeCompleted(node.id),
                          isUnlocked: state.isNodeUnlocked(node),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
