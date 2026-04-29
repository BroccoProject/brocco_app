import 'recipe_step.dart';

class Recipe {
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
  final List<RecipeStep> steps;

  const Recipe({
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
}
