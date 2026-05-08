import 'package:flutter/material.dart';
import 'package:brocco_app/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:image_picker/image_picker.dart';

Future<void> showMediaPickerBottomSheet({
  required BuildContext context,
  required ImagePicker picker,
  required Function(XFile) onPhotoPicked,
  required Function(XFile) onVideoPicked,
}) async {
  final l10n = AppLocalizations.of(context)!;
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (BuildContext context) {
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
                l10n.takePhoto,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              onTap: () async {
                Navigator.pop(context);
                final XFile? photo = await picker.pickImage(
                  source: ImageSource.camera,
                );
                if (photo != null) {
                  onPhotoPicked(photo);
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
                l10n.chooseFromGallery,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  onPhotoPicked(image);
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
                l10n.recordVideo,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              onTap: () async {
                Navigator.pop(context);
                final XFile? video = await picker.pickVideo(
                  source: ImageSource.camera,
                  maxDuration: const Duration(seconds: 60),
                );
                if (video != null) {
                  final size = await video.length();
                  if (size > 100 * 1024 * 1024) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.fileTooLarge)),
                    );
                    return;
                  }
                  onVideoPicked(video);
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
                l10n.chooseVideoFromGallery,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              onTap: () async {
                Navigator.pop(context);
                final XFile? video = await picker.pickVideo(
                  source: ImageSource.gallery,
                  maxDuration: const Duration(seconds: 60),
                );
                if (video != null) {
                  final size = await video.length();
                  if (size > 100 * 1024 * 1024) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.fileTooLarge)),
                    );
                    return;
                  }
                  onVideoPicked(video);
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
