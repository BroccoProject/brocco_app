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
import 'fullscreen_media_viewer.dart';
import 'video_thumbnail_widget.dart';

class MasterpieceGallery extends ConsumerWidget {
  const MasterpieceGallery({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    ref.listen<AsyncValue<void>>(
      profileActionProvider,
      (previous, next) {
        if (next.isLoading && previous?.isLoading != true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                  const SizedBox(width: 16),
                  Text(
                    l10n.uploadingMedia,
                    style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              backgroundColor: AppColors.primaryOrange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              elevation: 4,
              duration: const Duration(days: 1),
            ),
          );
        } else if (!next.isLoading && previous?.isLoading == true) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          if (next.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  next.error.toString(),
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16),
                ),
                backgroundColor: AppColors.primaryOrange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  l10n.uploadCompleted,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16),
                ),
                backgroundColor: AppColors.accentGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        }
      },
    );

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
              child: GestureDetector(
                onTap: () {
                  if (node.hasUserPhoto && node.imageUrl != null) {
                    final isVideo = node.imageUrl!.contains('.mp4') ||
                        node.imageUrl!.contains('video') ||
                        node.imageUrl!.endsWith('.mov') ||
                        node.imageUrl!.endsWith('.avi');
                    showGeneralDialog(
                      context: context,
                      barrierColor: Colors.black,
                      barrierDismissible: false,
                      transitionDuration: const Duration(milliseconds: 300),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return FullscreenMediaViewer(
                          title: node.title,
                          mediaUrl: node.imageUrl!,
                          isVideo: isVideo,
                        );
                      },
                    );
                  }
                },
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
                      if (node.hasUserPhoto &&
                          node.imageUrl != null &&
                          (node.imageUrl!.contains('.mp4') ||
                              node.imageUrl!.contains('video') ||
                              node.imageUrl!.endsWith('.mov') ||
                              node.imageUrl!.endsWith('.avi')))
                        const Center(
                          child: Icon(
                            Icons.play_circle_outline,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      if (!node.hasUserPhoto)
                        Container(
                          color: Colors.black.withValues(alpha: 0.2),
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

    final isVideo = node.imageUrl!.contains('.mp4') ||
        node.imageUrl!.contains('video') ||
        node.imageUrl!.endsWith('.mov') ||
        node.imageUrl!.endsWith('.avi');

    if (isVideo) {
      final Widget videoPlaceholder = VideoThumbnailWidget(
        videoUrl: node.imageUrl!,
        fit: BoxFit.cover,
      );
      if (!node.hasUserPhoto) {
        return ColorFiltered(
          colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
          child: videoPlaceholder,
        );
      }
      return videoPlaceholder;
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.greyText.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: AppColors.primaryOrange,
                  ),
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
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.photo_library,
                    color: AppColors.primaryOrange,
                  ),
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
              Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: AppColors.greyText.withValues(alpha: 0.15),
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.videocam,
                    color: AppColors.accentGreen,
                  ),
                ),
                title: Text(
                  l10n.recordVideoBonusXP,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  final XFile? video = await picker.pickVideo(
                    source: ImageSource.camera,
                    maxDuration: const Duration(seconds: 60),
                  );
                  if (video != null) {
                    final size = await video.length();
                    if (size > 100 * 1024 * 1024) {
                      if (!ctx.mounted) return;
                      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(l10n.errorWithDetail("File is too large (max 100MB)"))));
                      return;
                    }
                    ref
                        .read(profileActionProvider.notifier)
                        .uploadMissingVideo(nodeId, File(video.path));
                  }
                },
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.video_library,
                    color: AppColors.accentGreen,
                  ),
                ),
                title: Text(
                  l10n.chooseVideoFromGalleryBonusXP,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  final XFile? video = await picker.pickVideo(
                    source: ImageSource.gallery,
                    maxDuration: const Duration(seconds: 60),
                  );
                  if (video != null) {
                    final size = await video.length();
                    if (size > 100 * 1024 * 1024) {
                      if (!ctx.mounted) return;
                      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(l10n.errorWithDetail("File is too large (max 100MB)"))));
                      return;
                    }
                    ref
                        .read(profileActionProvider.notifier)
                        .uploadMissingVideo(nodeId, File(video.path));
                  }
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
