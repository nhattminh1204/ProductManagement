class DashboardStats {
  final int totalOrders;
  final double totalRevenue;
  final int totalProducts;
  final int totalUsers;
  final List<dynamic> recentOrders;
  final List<TopProduct> topProducts;
  final Map<String, int> orderStatsByStatus;

  DashboardStats({
    required this.totalOrders,
    required this.totalRevenue,
    required this.totalProducts,
    required this.totalUsers,
    required this.recentOrders,
    required this.topProducts,
    required this.orderStatsByStatus,
  });
}

class TopProduct {
  final int productId;
  final String productName;
  final int totalSold;
  final double totalRevenue;

  TopProduct({
    required this.productId,
    required this.productName,
    required this.totalSold,
    required this.totalRevenue,
  });
}

