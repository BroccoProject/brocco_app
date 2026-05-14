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
import 'widgets/reward_summary_card.dart';
import 'widgets/media_preview_box.dart';
import 'widgets/media_picker_bottom_sheet.dart';

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
    await showMediaPickerBottomSheet(
      context: context,
      picker: _picker,
      onPhotoPicked: (photo) {
        setState(() {
          _capturedImage = File(photo.path);
          _capturedVideo = null;
          _videoController?.dispose();
          _videoController = null;
        });
      },
      onVideoPicked: (video) async {
        setState(() {
          _capturedVideo = File(video.path);
          _capturedImage = null;
        });
        await _initVideoController(File(video.path));
      },
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
                        const RewardSummaryCard(),
                        const SizedBox(height: 24),
                        MediaPreviewBox(
                          capturedImage: _capturedImage,
                          capturedVideo: _capturedVideo,
                          videoController: _videoController,
                          onPickMedia: _pickMedia,
                          onToggleVideoPlay: () {
                            setState(() {
                              if (_videoController!.value.isPlaying) {
                                _videoController!.pause();
                              } else {
                                _videoController!.play();
                              }
                            });
                          },
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
