import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:brocco_app/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/roadmap_node.dart';

class RoadmapNodeTile extends StatelessWidget {
  final RoadmapNode node;
  final bool isCompleted;
  final bool isUnlocked;

  const RoadmapNodeTile({
    super.key,
    required this.node,
    required this.isCompleted,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = !isCompleted && !isUnlocked;
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: isLocked
          ? null
          : () {
              HapticFeedback.lightImpact();
              if (node.recipeId != null) {
                final encodedTitle = Uri.encodeComponent(node.title);
                context.push('/recipe/${node.recipeId}?nodeId=${node.id}&categoryId=${node.categoryId}&recipeTitle=$encodedTitle');
              }
            },
      child: SizedBox(
        width: 140,
        height: 164,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 106,
                  height: 106,
                  decoration: BoxDecoration(
                    color: isLocked
                        ? Colors.white.withValues(alpha: 0.6)
                        : Colors.white,
                    border: Border.all(
                      color: isCompleted || isUnlocked
                          ? AppColors.accentGreen
                          : AppColors.greyText.withValues(alpha: 0.3),
                      width: isCompleted ? 2.5 : 1.5,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: isLocked
                            ? Colors.transparent
                            : AppColors.accentGreen,
                        offset: const Offset(0, 5),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(19),
                    child: node.previewImageUrl != null
                        ? ColorFiltered(
                            colorFilter: isLocked
                                ? const ColorFilter.mode(
                                    Colors.grey, BlendMode.saturation)
                                : const ColorFilter.mode(
                                    Colors.transparent, BlendMode.dst),
                            child: CachedNetworkImage(
                              imageUrl: node.previewImageUrl!,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  _nodePlaceholder(isLocked),
                            ),
                          )
                        : _nodePlaceholder(isLocked),
                  ),
                ),
                if (isCompleted)
                  Positioned(
                    top: -9,
                    right: -9,
                    child: Transform.rotate(
                      angle: 0.1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.darkOrange,
                              offset: Offset(0, 3),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.done,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(Icons.check, color: Colors.white, size: 14),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              node.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isLocked ? AppColors.greyText : AppColors.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nodePlaceholder(bool locked) {
    return Container(
      color: locked
          ? AppColors.greyText.withValues(alpha: 0.1)
          : AppColors.accentGreen.withValues(alpha: 0.15),
      child: Center(
        child: Icon(
          Icons.restaurant_rounded,
          size: 38,
          color: locked ? AppColors.greyText : AppColors.accentGreen,
        ),
      ),
    );
  }
}
