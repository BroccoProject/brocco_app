import 'package:flutter/material.dart';
import 'package:brocco_app/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

class MediaPreviewBox extends StatelessWidget {
  final File? capturedImage;
  final File? capturedVideo;
  final VideoPlayerController? videoController;
  final VoidCallback onPickMedia;
  final VoidCallback onToggleVideoPlay;

  const MediaPreviewBox({
    super.key,
    required this.capturedImage,
    required this.capturedVideo,
    required this.videoController,
    required this.onPickMedia,
    required this.onToggleVideoPlay,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPickMedia,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.accentGreen.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (capturedVideo != null &&
        videoController != null &&
        videoController!.value.isInitialized) {
      return Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: videoController!.value.aspectRatio,
              child: VideoPlayer(videoController!),
            ),
          ),
          GestureDetector(
            onTap: onToggleVideoPlay,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                videoController!.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ],
      );
    }

    if (capturedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          capturedImage!,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.accentGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: Icon(
              Icons.camera_alt_outlined,
              color: AppColors.primaryOrange,
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.captureMasterpiece,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.addPhotoBonus,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.greyText,
            fontSize: 13,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
