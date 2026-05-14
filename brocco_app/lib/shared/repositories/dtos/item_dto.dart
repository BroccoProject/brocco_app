class ItemDto {
  final String id;
  final String name;
  final Map<String, dynamic> nameI18n;
  final String tag;

  const ItemDto({
    required this.id,
    required this.name,
    this.nameI18n = const {},
    required this.tag,
  });

  factory ItemDto.fromJson(Map<String, dynamic> json) {
    final itemData = json['items'] as Map<String, dynamic>?;

    return ItemDto(
      id: (itemData?['id'] ?? json['id']) as String,
      name: (itemData?['name'] ?? json['name']) as String,
      nameI18n:
          (itemData?['name_i18n'] ?? json['name_i18n']) as Map<String, dynamic>? ??
              const {},
      tag: (itemData?['tag'] ?? json['tag']) as String,
    );
  }
}
