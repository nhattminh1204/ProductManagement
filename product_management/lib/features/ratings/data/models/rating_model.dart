class RatingModel {
  final int id;
  final int productId;
  final int userId;
  final int rating; // 1-5
  final String? comment;
  final DateTime createdDate;
  final String? userName;
  final String? productName;

  RatingModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.rating,
    this.comment,
    required this.createdDate,
    this.userName,
    this.productName,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'] ?? 0,
      productId: json['productId'] ?? 0,
      userId: json['userId'] ?? 0,
      rating: json['rating'] ?? 0,
      comment: json['comment'],
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : DateTime.now(),
      userName: json['userName'],
      productName: json['productName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'createdDate': createdDate.toIso8601String(),
      'userName': userName,
      'productName': productName,
    };
  }
}


