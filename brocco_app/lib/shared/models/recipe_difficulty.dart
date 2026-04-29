import 'package:flutter/material.dart';

enum RecipeDifficulty {
  beginner('Begginner', 'Łatwy', 1, 1),
  intermediate('Intermediate', 'Średni', 2, 2),
  masterChef('Master Chef', 'Trudny', 3, 3);

  final String dbValue;
  final String label;
  final int score;
  final int starCount;

  const RecipeDifficulty(
    this.dbValue,
    this.label,
    this.score,
    this.starCount,
  );

  static RecipeDifficulty fromString(String? value) {
    if (value == null) return RecipeDifficulty.intermediate;
    final lower = value.toLowerCase();
    if (lower.contains('begginner')) return RecipeDifficulty.beginner;
    if (lower.contains('master chef') || lower.contains('master')) return RecipeDifficulty.masterChef;
    return RecipeDifficulty.intermediate;
  }
}
