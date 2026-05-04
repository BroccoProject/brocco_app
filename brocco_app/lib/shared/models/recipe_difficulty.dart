import 'package:brocco_app/l10n/generated/app_localizations.dart';

enum RecipeDifficulty {
  beginner('Beginner', 'Easy', 1, 1),
  intermediate('Intermediate', 'Medium', 2, 2),
  masterChef('Master Chef', 'Hard', 3, 3);

  final String dbValue;
  final String label; // Keep for fallback
  final int score;
  final int starCount;

  const RecipeDifficulty(
    this.dbValue,
    this.label,
    this.score,
    this.starCount,
  );

  String getLabel(AppLocalizations l10n) {
    switch (this) {
      case RecipeDifficulty.beginner:
        return l10n.easy;
      case RecipeDifficulty.intermediate:
        return l10n.medium;
      case RecipeDifficulty.masterChef:
        return l10n.hard;
    }
  }

  static RecipeDifficulty fromString(String? value) {
    if (value == null) return RecipeDifficulty.intermediate;
    final lower = value.toLowerCase();
    if (lower.contains('begginner')) return RecipeDifficulty.beginner;
    if (lower.contains('master chef') || lower.contains('master')) return RecipeDifficulty.masterChef;
    return RecipeDifficulty.intermediate;
  }
}
