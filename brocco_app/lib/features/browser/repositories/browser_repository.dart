import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/models/recipe.dart';
import '../../../shared/repositories/dtos/isar_recipe.dart';
import '../../../core/local_db/isar_provider.dart';

class BrowserRepository {
  final Isar _isar;
  final SupabaseClient _client;
  static const _noRecipeFallback = 'No recipe available yet';

  BrowserRepository(this._isar, this._client);

  Future<List<Recipe>> getRecipes() async {
    final isarRecipes = await _isar.isarRecipes.where().findAll();

    if (isarRecipes.isEmpty) {
      final response = await _client
          .from('recipes')
          .select('''
            id,
            title,
            description,
            image_url,
            difficulty_level,
            duration_minutes,
            youtube_url,
            tags,
            category,
            area,
            source_url,
            recipe_steps(instruction, step_number)
          ''')
          .order('step_number', referencedTable: 'recipe_steps');
      final rows = response as List;

      await _isar.writeTxn(() async {
        for (final row in rows) {
          final recipe = IsarRecipe()
            ..supabaseId = row['id'] as String
            ..title = row['title'] as String?
            ..description = row['description'] as String?
            ..instructionsPlaintext = _buildRecipePlaintext(
              row['recipe_steps'] as List<dynamic>?,
            )
            ..imageUrl = row['image_url'] as String?
            ..difficultyLevel = row['difficulty_level'] as String?
            ..durationMinutes = row['duration_minutes'] as int?
            ..youtubeUrl = row['youtube_url'] as String?
            ..tags = (row['tags'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList()
            ..category = row['category'] as String?
            ..area = row['area'] as String?
            ..sourceUrl = row['source_url'] as String?;
          await _isar.isarRecipes.put(recipe);
        }
      });

      final updatedIsarRecipes = await _isar.isarRecipes.where().findAll();
      return updatedIsarRecipes.map(_mapIsarRecipe).toList();
    }

    return isarRecipes.map(_mapIsarRecipe).toList();
  }

  String _buildRecipePlaintext(List<dynamic>? rawSteps) {
    final steps = (rawSteps ?? const [])
        .map((e) => e as Map<String, dynamic>)
        .toList()
      ..sort(
        (a, b) => ((a['step_number'] as int?) ?? 0).compareTo(
          (b['step_number'] as int?) ?? 0,
        ),
      );

    if (steps.isEmpty) return _noRecipeFallback;

    final joined = steps
        .map((step) => (step['instruction'] as String?)?.trim() ?? '')
        .where((instruction) => instruction.isNotEmpty)
        .join('\n');

    return joined.isEmpty ? _noRecipeFallback : joined;
  }

  Recipe _mapIsarRecipe(IsarRecipe dto) {
    return Recipe(
      id: dto.supabaseId ?? '',
      title: dto.title ?? '',
      description: dto.description,
      imageUrl: dto.imageUrl,
      difficultyLevel: dto.difficultyLevel,
      durationMinutes: dto.durationMinutes,
      youtubeUrl: dto.youtubeUrl,
      tags: dto.tags,
      category: dto.category,
      area: dto.area,
      sourceUrl: dto.sourceUrl,
      steps: const [],
    );
  }
}

final browserRepositoryProvider = Provider<BrowserRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return BrowserRepository(isar, Supabase.instance.client);
});
