import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:brocco_app/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfileHeaderCard extends ConsumerWidget {
  const ProfileHeaderCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profileAsync = ref.watch(userProfileLogicProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.accentGreen, width: 2),
        boxShadow: const [
          BoxShadow(
            color: AppColors.accentGreen,
            offset: Offset(0, 5),
            blurRadius: 0,
          ),
        ],
      ),
      child: profileAsync.when(
        data: (profile) {
          if (profile == null) return Center(child: Text(l10n.noRecipeFallback));
          
          final int totalXp = profile.totalXp;
          final int level = (totalXp ~/ 1000);
          final int currentXp = totalXp % 1000;
          final double progress = currentXp / 1000;

          return Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _pickAndUploadAvatar(context, ref),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primaryOrange, width: 3),
                          ),
                          child: ClipOval(
                            child: profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: profile.avatarUrl!,
                                    fit: BoxFit.cover,
                                    width: 80,
                                    height: 80,
                                    errorWidget: (context, url, error) => 
                                        const Icon(Icons.person_outline, size: 40, color: AppColors.greyText),
                                  )
                                : const Icon(Icons.person_outline, size: 40, color: AppColors.greyText),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryOrange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$level',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.username ?? l10n.userFallback,
                          style: const TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.xpToNextRank(currentXp),
                          style: const TextStyle(color: AppColors.greyText, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: AppColors.primaryOrange.withValues(alpha: 0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryOrange),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.accentGreen, width: 1.5),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.accentGreen,
                            offset: Offset(0, 3),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.local_fire_department_rounded, color: AppColors.primaryOrange, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            l10n.daysStreak(profile.currentStreak),
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.primaryText),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.accentGreen, width: 1.5),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.accentGreen,
                            offset: Offset(0, 3),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star_rounded, color: AppColors.primaryOrange, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            l10n.starsCount(profile.starsBank),
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.primaryText),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.errorWithDetail(e.toString()))),
      ),
    );
  }

  Future<void> _pickAndUploadAvatar(BuildContext context, WidgetRef ref) async {
    final ImagePicker picker = ImagePicker();
    final l10n = AppLocalizations.of(context)!;
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primaryOrange),
                title: Text(l10n.takeProfilePhoto, style: const TextStyle(fontWeight: FontWeight.w800)),
                onTap: () async {
                  Navigator.pop(ctx);
                  final XFile? photo = await picker.pickImage(
                    source: ImageSource.camera,
                    maxWidth: 400,
                    maxHeight: 400,
                    imageQuality: 85,
                  );
                  if (photo != null) {
                    ref.read(profileActionProvider.notifier).updateAvatar(File(photo.path));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.primaryOrange),
                title: Text(l10n.chooseFromGallery, style: const TextStyle(fontWeight: FontWeight.w800)),
                onTap: () async {
                  Navigator.pop(ctx);
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                    maxWidth: 400,
                    maxHeight: 400,
                    imageQuality: 85,
                  );
                  if (image != null) {
                    ref.read(profileActionProvider.notifier).updateAvatar(File(image.path));
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
