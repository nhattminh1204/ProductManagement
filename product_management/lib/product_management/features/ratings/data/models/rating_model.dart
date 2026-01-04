class RatingModel {
  final int? id;
  final int productId;
  final int userId;
  final int rating;
  final String? comment;
  final DateTime? createdAt;
  final String? userName; // Augmented field for UI

  RatingModel({
    this.id,
    required this.productId,
    required this.userId,
    required this.rating,
    this.comment,
    this.createdAt,
    this.userName,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'],
      productId: json['product_id'] ?? json['productId'],
      userId: json['user_id'] ?? json['userId'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at']) 
          : (json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null),
      userName: json['user_name'] ?? json['userName'] ?? 'User ${json['user_id'] ?? ''}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId, // API expects camelCase
      'userId': userId,
      'rating': rating,
      'comment': comment,
    };
  }
}
