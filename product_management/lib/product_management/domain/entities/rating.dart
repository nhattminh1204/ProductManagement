class Rating {
  final int? id;
  final int productId;
  final int userId;
  final int rating;
  final String? comment;
  final DateTime? createdAt;
  final String? userName;

  Rating({
    this.id,
    required this.productId,
    required this.userId,
    required this.rating,
    this.comment,
    this.createdAt,
    this.userName,
  });
}
