import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:brocco_app/l10n/generated/app_localizations.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../viewmodels/level_completed_viewmodel.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class LevelCompletedScreen extends ConsumerStatefulWidget {
  final String nodeId;
  final String categoryId;
  final String recipeTitle;

  const LevelCompletedScreen({
    super.key,
    required this.nodeId,
    required this.categoryId,
    required this.recipeTitle,
  });

  @override
  ConsumerState<LevelCompletedScreen> createState() =>
      _LevelCompletedScreenState();
}

class _LevelCompletedScreenState extends ConsumerState<LevelCompletedScreen> {
  File? _capturedImage;
  File? _capturedVideo;
  VideoPlayerController? _videoController;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.nodeId.isNotEmpty && widget.categoryId.isNotEmpty) {
        ref
            .read(levelCompletedViewModelProvider.notifier)
            .completeLevel(widget.nodeId, widget.categoryId);
      }
      _audioPlayer.play(AssetSource('audio/fanfare.mp3'));
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _initVideoController(File videoFile) async {
    await _videoController?.dispose();
    final controller = VideoPlayerController.file(videoFile);
    await controller.initialize();
    controller.setLooping(true);
    controller.play();
    if (mounted) {
      setState(() {
        _videoController = controller;
      });
    }
  }

  Future<void> _pickMedia() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        final l10n = AppLocalizations.of(context)!;
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
                  final XFile? photo = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (photo != null) {
                    setState(() {
                      _capturedImage = File(photo.path);
                      _capturedVideo = null;
                      _videoController?.dispose();
                      _videoController = null;
                    });
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
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    setState(() {
                      _capturedImage = File(image.path);
                      _capturedVideo = null;
                      _videoController?.dispose();
                      _videoController = null;
                    });
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
                  final XFile? video = await _picker.pickVideo(
                    source: ImageSource.camera,
                    maxDuration: const Duration(seconds: 60),
                  );
                  if (video != null) {
                    final size = await video.length();
                    if (size > 100 * 1024 * 1024) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.fileTooLarge)));
                      return;
                    }
                    setState(() {
                      _capturedVideo = File(video.path);
                      _capturedImage = null;
                    });
                    await _initVideoController(File(video.path));
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
                  final XFile? video = await _picker.pickVideo(
                    source: ImageSource.gallery,
                    maxDuration: const Duration(seconds: 60),
                  );
                  if (video != null) {
                    final size = await video.length();
                    if (size > 100 * 1024 * 1024) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.fileTooLarge)));
                      return;
                    }
                    setState(() {
                      _capturedVideo = File(video.path);
                      _capturedImage = null;
                    });
                    await _initVideoController(File(video.path));
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

  Widget _buildMediaPreview() {
    if (_capturedVideo != null && _videoController != null && _videoController!.value.isInitialized) {
      return Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                if (_videoController!.value.isPlaying) {
                  _videoController!.pause();
                } else {
                  _videoController!.play();
                }
              });
            },
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ],
      );
    }

    if (_capturedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          _capturedImage!,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

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
          AppLocalizations.of(context)!.captureMasterpiece,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.addPhotoBonus,
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF2FAF5),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Image.asset(
                        'assets/images/characters/mascot_happy.png',
                        height: 180,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.eco_rounded, size: 120, color: AppColors.accentGreen),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l10n.levelCompleted,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.completedRecipeFor(widget.recipeTitle),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF1E5B43),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (widget.categoryId.isNotEmpty) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.accentGreen.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.rewardsToCollect,
                                style: const TextStyle(
                                  color: AppColors.greyText,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryOrange,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.star_rounded,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          Text(
                                            '+150',
                                            style: TextStyle(
                                              color: AppColors.primaryText,
                                              fontSize: 36,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: -1,
                                            ),
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            l10n.xpAbbr,
                                            style: TextStyle(
                                              color: AppColors.primaryText,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        l10n.experiencePoints,
                                        style: const TextStyle(
                                          color: AppColors.greyText,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: _pickMedia,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: AppColors.accentGreen.withValues(
                                  alpha: 0.5,
                                ),
                                width: 2,
                              ),
                            ),
                            child: _buildMediaPreview(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: PrimaryButton(
                text: widget.categoryId.isNotEmpty ? l10n.claimRewardsAndFinish : l10n.finish,
                isLoading: _isUploading,
                onPressed: () async {
                  if (_isUploading) return;
                  
                  final notifier = ref.read(levelCompletedViewModelProvider.notifier);
                  try {
                    setState(() => _isUploading = true);
                    
                    if (_capturedVideo != null && widget.nodeId.isNotEmpty && widget.categoryId.isNotEmpty) {
                      await notifier.uploadMealVideo(
                        widget.nodeId,
                        widget.categoryId,
                        _capturedVideo!,
                      );
                    } else if (_capturedImage != null && widget.nodeId.isNotEmpty && widget.categoryId.isNotEmpty) {
                      await notifier.uploadMealPhoto(
                        widget.nodeId,
                        widget.categoryId,
                        _capturedImage!,
                      );
                    }
                    
                    if (!mounted) return;
                    final state = ref.read(levelCompletedViewModelProvider);
                    if (state.hasError) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error.toString())));
                      setState(() => _isUploading = false);
                      return;
                    }

                    if (widget.categoryId.isNotEmpty) {
                      context.go('/roadmap/${widget.categoryId}');
                    } else {
                      context.go('/');
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                      setState(() => _isUploading = false);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
