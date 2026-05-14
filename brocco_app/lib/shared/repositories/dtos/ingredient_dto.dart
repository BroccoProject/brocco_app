class IngredientDto {
  final String id;
  final String name;
  final Map<String, dynamic> nameI18n;
  final double? amount;
  final String? unit;
  final int sortOrder;

  const IngredientDto({
    required this.id,
    required this.name,
    this.nameI18n = const {},
    this.amount,
    this.unit,
    this.sortOrder = 0,
  });

  factory IngredientDto.fromJson(Map<String, dynamic> json) {
    final ingredientData = json['ingredients'] as Map<String, dynamic>?;

    return IngredientDto(
      id: (ingredientData?['id'] ?? json['id']) as String,
      name: (ingredientData?['name'] ?? json['name']) as String,
      nameI18n: (ingredientData?['name_i18n'] ?? json['name_i18n'])
              as Map<String, dynamic>? ??
          const {},
      amount: (json['amount'] as num?)?.toDouble(),
      unit: json['unit'] as String?,
      sortOrder: (json['sort_order'] as int?) ?? 0,
    );
  }
}
