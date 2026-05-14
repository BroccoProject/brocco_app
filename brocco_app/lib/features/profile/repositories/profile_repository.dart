import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/local_db/isar_provider.dart';
import '../../../shared/models/user_profile.dart';
import '../../roadmap/repositories/dtos/isar_completed_node.dart';
import '../../roadmap/repositories/dtos/isar_roadmap_node.dart';
import '../models/completed_node_data.dart';
import 'dtos/isar_profile.dart';
import 'package:video_compress/video_compress.dart';

class ProfileRepository {
  final Isar _isar;
  final SupabaseClient _supabase;

  ProfileRepository(this._isar, this._supabase);

  Stream<UserProfile?> watchUserProfile(String userId) {
    return _isar.isarProfiles
        .where()
        .supabaseUserIdEqualTo(userId)
        .watch(fireImmediately: true)
        .map(
          (results) => results.firstOrNull != null
              ? UserProfile.fromIsar(results.firstOrNull!)
              : null,
        );
  }

  Stream<List<CompletedNodeData>> watchGalleryNodes(String userId) async* {
    final query = _isar.isarCompletedNodes.where().userIdEqualToAnyNodeId(
      userId,
    );

    await for (final nodes in query.watch(fireImmediately: true)) {
      final List<CompletedNodeData> mappedNodes = [];
      for (final node in nodes) {
        if (node.nodeId == null) continue;
        final roadmapNode = await _isar.isarRoadmapNodes
            .where()
            .supabaseIdEqualTo(node.nodeId!)
            .findFirst();

        mappedNodes.add(
          CompletedNodeData(
            id: node.nodeId!,
            title: roadmapNode?.title ?? 'Unknown dish',
            imageUrl: node.imageUrl ?? roadmapNode?.previewImageUrl,
            hasUserPhoto: node.imageUrl != null,
          ),
        );
      }
      yield mappedNodes;
    }
  }

  Future<void> uploadMealPhoto({
    required String userId,
    required String nodeId,
    required File photoFile,
  }) async {
    final targetPath =
        '${photoFile.absolute.parent.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      photoFile.absolute.path,
      targetPath,
      quality: 70,
    );
    final uploadFile = compressedFile != null
        ? File(compressedFile.path)
        : photoFile;

    final fileName = '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
    await _supabase.storage.from('meal_photos').upload(fileName, uploadFile);
    final imageUrl = _supabase.storage
        .from('meal_photos')
        .getPublicUrl(fileName);

    final isFirstTime = await _isar.writeTxn(() async {
      final completedNode = await _isar.isarCompletedNodes
          .where()
          .userIdEqualToAnyNodeId(userId)
          .findAll()
          .then((nodes) => nodes.where((n) => n.nodeId == nodeId).firstOrNull);

      bool firstTime = false;
      if (completedNode != null) {
        firstTime = completedNode.imageUrl == null;
        completedNode.imageUrl = imageUrl;
        await _isar.isarCompletedNodes.put(completedNode);

        if (firstTime) {
          final profile = await _isar.isarProfiles
              .where()
              .supabaseUserIdEqualTo(userId)
              .findFirst();

          if (profile != null) {
            profile.totalXp += 50;
            await _isar.isarProfiles.put(profile);
          }
        }
      }
      return firstTime;
    });

    await _supabase
        .from('user_completed_nodes')
        .update({'image_url': imageUrl})
        .eq('user_id', userId)
        .eq('node_id', nodeId);

    if (isFirstTime) {
      final profileResponse = await _supabase
          .from('profiles')
          .select('total_xp')
          .eq('id', userId)
          .single();

      await _supabase
          .from('profiles')
          .update({'total_xp': (profileResponse['total_xp'] as int) + 50})
          .eq('id', userId);
    }
  }

  Future<void> uploadMealVideo({
    required String userId,
    required String nodeId,
    required File videoFile,
  }) async {
    final mediaInfo = await VideoCompress.compressVideo(
      videoFile.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
    );
    final uploadFile = mediaInfo != null && mediaInfo.file != null ? mediaInfo.file! : videoFile;

    final fileName = '$userId/${DateTime.now().millisecondsSinceEpoch}.mp4';
    await _supabase.storage.from('meal_photos').upload(fileName, uploadFile);
    final videoUrl = _supabase.storage
        .from('meal_photos')
        .getPublicUrl(fileName);

    final isFirstTime = await _isar.writeTxn(() async {
      final completedNode = await _isar.isarCompletedNodes
          .where()
          .userIdEqualToAnyNodeId(userId)
          .findAll()
          .then((nodes) => nodes.where((n) => n.nodeId == nodeId).firstOrNull);

      bool firstTime = false;
      if (completedNode != null) {
        firstTime = completedNode.imageUrl == null;
        completedNode.imageUrl = videoUrl;
        await _isar.isarCompletedNodes.put(completedNode);

        if (firstTime) {
          final profile = await _isar.isarProfiles
              .where()
              .supabaseUserIdEqualTo(userId)
              .findFirst();

          if (profile != null) {
            profile.totalXp += 50;
            await _isar.isarProfiles.put(profile);
          }
        }
      }
      return firstTime;
    });

    await _supabase
        .from('user_completed_nodes')
        .update({'image_url': videoUrl})
        .eq('user_id', userId)
        .eq('node_id', nodeId);

    if (isFirstTime) {
      final profileResponse = await _supabase
          .from('profiles')
          .select('total_xp')
          .eq('id', userId)
          .single();

      await _supabase
          .from('profiles')
          .update({'total_xp': (profileResponse['total_xp'] as int) + 50})
          .eq('id', userId);
    }
  }

  Future<void> updateAvatar({
    required String userId,
    required File photoFile,
  }) async {
    final targetPath =
        '${photoFile.absolute.parent.path}/compressed_avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      photoFile.absolute.path,
      targetPath,
      quality: 70,
    );
    final uploadFile = compressedFile != null
        ? File(compressedFile.path)
        : photoFile;

    final fileName =
        '$userId/avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';

    String imageUrl;
    try {
      await _supabase.storage.from('avatars').upload(fileName, uploadFile);
      imageUrl = _supabase.storage.from('avatars').getPublicUrl(fileName);
    } catch (e) {
      await _supabase.storage.from('meal_photos').upload(fileName, uploadFile);
      imageUrl = _supabase.storage.from('meal_photos').getPublicUrl(fileName);
    }

    await _isar.writeTxn(() async {
      final profile = await _isar.isarProfiles
          .where()
          .supabaseUserIdEqualTo(userId)
          .findFirst();

      if (profile != null) {
        profile.avatarUrl = imageUrl;
        await _isar.isarProfiles.put(profile);
      }
    });

    await _supabase
        .from('profiles')
        .update({'avatar_url': imageUrl})
        .eq('id', userId);
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(isarProvider), Supabase.instance.client);
});
