import '../../../features/recipe_detail/repositories/dtos/recipe_step_dto.dart';

class RecipeDto {
  final String id;
  final String title;
  final Map<String, dynamic> titleI18n;
  final String? description;
  final Map<String, dynamic> descriptionI18n;
  final String? imageUrl;
  final String? difficultyLevel;
  final int? durationMinutes;
  final String? youtubeUrl;
  final List<String>? tags;
  final String? category;
  final String? area;
  final String? sourceUrl;
  final List<RecipeStepDto> steps;

  const RecipeDto({
    required this.id,
    required this.title,
    this.titleI18n = const {},
    this.description,
    this.descriptionI18n = const {},
    this.imageUrl,
    this.difficultyLevel,
    this.durationMinutes,
    this.youtubeUrl,
    this.tags,
    this.category,
    this.area,
    this.sourceUrl,
    this.steps = const [],
  });

  factory RecipeDto.fromJson(Map<String, dynamic> json) {
    return RecipeDto(
      id: json['id'] as String,
      title: json['title'] as String,
      titleI18n: json['title_i18n'] as Map<String, dynamic>? ?? const {},
      description: json['description'] as String?,
      descriptionI18n:
          json['description_i18n'] as Map<String, dynamic>? ?? const {},
      imageUrl: json['image_url'] as String?,
      difficultyLevel: json['difficulty_level'] as String?,
      durationMinutes: json['duration_minutes'] as int?,
      youtubeUrl: json['youtube_url'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      category: json['category'] as String?,
      area: json['area'] as String?,
      sourceUrl: json['source_url'] as String?,
      steps: (json['recipe_steps'] as List<dynamic>?)
              ?.map((e) => RecipeStepDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}
