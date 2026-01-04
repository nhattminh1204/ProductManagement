class Rating {
  final int id;
  final int productId;
  final int userId;
  final int rating; // 1-5
  final String? comment;
  final DateTime createdDate;
  final String? userName;
  final String? productName;

  Rating({
    required this.id,
    required this.productId,
    required this.userId,
    required this.rating,
    this.comment,
    required this.createdDate,
    this.userName,
    this.productName,
  });
}


