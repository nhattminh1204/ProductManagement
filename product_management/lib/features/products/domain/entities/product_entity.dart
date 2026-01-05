class Product {
  final int id;
  final String name;
  final String? image;
  final double price;
  final int quantity;
  final String status;
  final int categoryId;
  final String? categoryName;
  final double? averageRating;
  final int? totalRatings;
  final String? description;

  Product({
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
}


