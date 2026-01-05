class DashboardStatsModel {
  final int totalOrders;
  final double totalRevenue;
  final int totalProducts;
  final int totalUsers;
  final List<dynamic> recentOrders;
  final List<TopProductModel> topProducts;
  final Map<String, int> orderStatsByStatus;

  DashboardStatsModel({
    required this.totalOrders,
    required this.totalRevenue,
    required this.totalProducts,
    required this.totalUsers,
    required this.recentOrders,
    required this.topProducts,
    required this.orderStatsByStatus,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalOrders: json['totalOrders'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      totalProducts: json['totalProducts'] ?? 0,
      totalUsers: json['totalUsers'] ?? 0,
      recentOrders: json['recentOrders'] ?? [],
      topProducts: (json['topProducts'] as List<dynamic>?)
              ?.map((e) => TopProductModel.fromJson(e))
              .toList() ??
          [],
      orderStatsByStatus: Map<String, int>.from(json['orderStatsByStatus'] ?? {}),
    );
  }
}

class TopProductModel {
  final int productId;
  final String productName;
  final int totalSold;
  final double totalRevenue;

  TopProductModel({
    required this.productId,
    required this.productName,
    required this.totalSold,
    required this.totalRevenue,
  });

  factory TopProductModel.fromJson(Map<String, dynamic> json) {
    return TopProductModel(
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? '',
      totalSold: json['totalSold'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
    );
  }
}

