class Item {
  final int id;
  final String name;
  final String description;
  final String? imagePath;

  Item({
    required this.id,
    required this.name,
    required this.description,
    this.imagePath,
  });
}