class ProductModel {
  final int id;
  final String name;
  final String? image;
  final double price;
  final int quantity;
  final String status; // active, inactive
  final int categoryId;
  final String? categoryName;
  final double? averageRating;
  final int? totalRatings;
  final String? description;

  ProductModel({
    required this.id,
    required this.name,
    this.image,
    required this.price,
    required this.quantity,
    required this.status,
    required this.categoryId,
    this.categoryName,
    this.averageRating,
    this.totalRatings,
    this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'],
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      status: json['status'] ?? 'active',
      categoryId: json['categoryId'] ?? 0,
      categoryName: json['categoryName'],
      averageRating: (json['averageRating'] != null) ? (json['averageRating'] as num).toDouble() : null,
      totalRatings: json['totalRatings'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
      'status': status,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'description': description,
    };
  }
}


