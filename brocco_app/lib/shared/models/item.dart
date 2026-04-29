class Item {
  final String id;
  final String name;
  final Map<String, dynamic> nameI18n;
  final String tag;

  const Item({
    required this.id,
    required this.name,
    this.nameI18n = const {},
    required this.tag,
  });
}
