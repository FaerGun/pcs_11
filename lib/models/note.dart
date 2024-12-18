class Sweet {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final int price;

  final bool isFavorite;
  int quantity;

  Sweet({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,

    this.isFavorite = false,
    this.quantity = 1,
  });

  factory Sweet.fromJson(Map<String, dynamic> json) {
    return Sweet(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
      price: json['price'],

      isFavorite: json['is_favorite'] ?? false,
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'price': price,
      'is_favorite': isFavorite,
      'quantity': quantity,
    };
  }
}