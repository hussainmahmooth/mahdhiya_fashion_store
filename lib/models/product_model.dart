class ProductModel {
  final String? id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final String description;
  final double rating;
  final int stock;

  ProductModel({
    this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    this.description = '',
    this.rating = 4.5,
    this.stock = 10,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'image_url': imageUrl,
      'description': description,
      'rating': rating,
      'stock': stock,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      id: id,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      imageUrl: map['image_url'] ?? '',
      description: map['description'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      stock: map['stock'] ?? 0,
    );
  }
}
