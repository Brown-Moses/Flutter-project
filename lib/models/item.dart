class Item {
  final int id;
  final String name;
  final int quantity;
  final String category;

  Item({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
  });

  Item copyWith({int? id, String? name, int? quantity, String? category}) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
    );
  }
} 