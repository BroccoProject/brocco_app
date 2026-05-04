import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:brocco_app/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/completed_node_data.dart';
import '../viewmodels/profile_viewmodel.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../shared/widgets/buttons/pushable_3d_button.dart';

class MasterpieceGallery extends ConsumerWidget {
  const MasterpieceGallery({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final nodesAsync = ref.watch(galleryNodesProvider);

    return nodesAsync.when(
      data: (nodes) {
        if (nodes.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  l10n.noCompletedRecipes,
                  style: const TextStyle(color: AppColors.greyText),
                ),
              ),
            ),
          );
        }

        return SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            final node = nodes[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.accentGreen, width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.accentGreen,
                    offset: Offset(0, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildImage(node),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.7),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: Text(
                        node.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (!node.hasUserPhoto)
                      Container(
                        color: Colors.black.withValues(alpha: 0.2), // Subtle dimming
                        child: Center(
                          child: Pushable3DButton(
                            borderRadius: BorderRadius.circular(100),
                            backgroundColor: AppColors.primaryOrange,
                            shadowColor: AppColors.darkOrange,
                            shadowOffset: 4,
                            padding: const EdgeInsets.all(12),
                            onPressed: () =>
                                _pickAndUpload(context, ref, node.id),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }, childCount: nodes.length),
        );
      },
      loading: () => const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) =>
          SliverToBoxAdapter(child: Center(child: Text(l10n.errorWithDetail(e.toString())))),
    );
  }

  Widget _buildImage(CompletedNodeData node) {
    if (node.imageUrl == null || node.imageUrl!.isEmpty) {
      return Container(
        color: AppColors.accentGreen.withValues(alpha: 0.2),
        child: const Icon(
          Icons.restaurant,
          size: 48,
          color: AppColors.accentGreen,
        ),
      );
    }

    final imageWidget = CachedNetworkImage(
      imageUrl: node.imageUrl!,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) => Container(
        color: AppColors.accentGreen.withValues(alpha: 0.2),
        child: const Icon(Icons.error, color: AppColors.primaryOrange),
      ),
    );

    if (!node.hasUserPhoto) {
      return ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
        child: imageWidget,
      );
    }
    return imageWidget;
  }

  Future<void> _pickAndUpload(
    BuildContext context,
    WidgetRef ref,
    String nodeId,
  ) async {
    final ImagePicker picker = ImagePicker();
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: AppColors.primaryOrange,
                ),
                title: Text(
                  l10n.takePhotoBonusXP,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  final XFile? photo = await picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (photo != null) {
                    ref
                        .read(profileActionProvider.notifier)
                        .uploadMissingPhoto(nodeId, File(photo.path));
                  }
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppColors.primaryOrange,
                ),
                title: Text(
                  l10n.chooseFromGalleryBonusXP,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    ref
                        .read(profileActionProvider.notifier)
                        .uploadMissingPhoto(nodeId, File(image.path));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
