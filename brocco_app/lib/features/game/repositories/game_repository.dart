import 'package:flutter_riverpod/flutter_riverpod.dart';

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  return GameRepository();
});

class GameRepository {
  static const noRecipeFallback = 'No recipe available yet';

  List<String> parseRecipeToSteps(String plaintext) {
    final normalized = plaintext.trim();
    if (normalized.isEmpty) return [];
    if (normalized == noRecipeFallback) return [noRecipeFallback];

    final rawSteps = normalized.split('.');

    final steps = rawSteps
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .map((s) => '$s.')
        .toList();

    return steps;
  }
}
