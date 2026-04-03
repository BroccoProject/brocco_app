class Ingredient {
  final String id;
  final String name;
  final Map<String, dynamic> nameI18n;
  final double? amount;
  final String? unit;
  final int sortOrder;

  const Ingredient({
    required this.id,
    required this.name,
    this.nameI18n = const {},
    this.amount,
    this.unit,
    this.sortOrder = 0,
  });

  String get formattedAmount {
    if (amount == null && unit == null) return '';
    final amountStr = amount != null
        ? (amount! % 1 == 0 ? amount!.toInt().toString() : amount.toString())
        : '';
    final unitStr = unit ?? '';
    return '$amountStr $unitStr'.trim();
  }
}
