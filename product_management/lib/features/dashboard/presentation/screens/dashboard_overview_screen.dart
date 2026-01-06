import 'package:flutter/material.dart';


import 'package:product_management/product_management/presentation/design_system.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart'; // Added
import '../providers/dashboard_provider.dart';
import '../../../../core/utils/price_formatter.dart';
import 'revenue_analytics_screen.dart';
import 'order_statistics_screen.dart';

class DashboardOverviewScreen extends StatefulWidget {
  final VoidCallback? onOpenDrawer;

  const DashboardOverviewScreen({super.key, this.onOpenDrawer});

  @override
  State<DashboardOverviewScreen> createState() =>
      _DashboardOverviewScreenState();
}

class _DashboardOverviewScreenState extends State<DashboardOverviewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchDashboardStats();
      context.read<DashboardProvider>().fetchTopProducts(10);
      context.read<DashboardProvider>().fetchRevenueByPeriod('month');
      context.read<DashboardProvider>().fetchOrderStatsByStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = context.watch<DashboardProvider>();
    final stats = dashboardProvider.stats;

    return Scaffold(
      backgroundColor: AppColors.background,
      // Drawer removed to use parent AdminMainScreen drawer
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => widget.onOpenDrawer?.call(),
          ),
        ),
        title: const Text('Overview'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: dashboardProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : dashboardProvider.error != null
          ? Center(child: Text('Error: ${dashboardProvider.error}'))
          : stats == null
          ? const Center(child: Text('No data available'))
          : RefreshIndicator(
              onRefresh: () async {
                await dashboardProvider.fetchDashboardStats();
                await dashboardProvider.fetchTopProducts(10);
                await dashboardProvider.fetchRevenueByPeriod('month');
                await dashboardProvider.fetchOrderStatsByStatus();
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            'Total Orders',
                            stats.totalOrders.toString(),
                            Icons.shopping_cart,
                            Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSummaryCard(
                            'Total Revenue',
                            stats.totalRevenue.formatPriceWithCurrency(),
                            Icons.attach_money,
                            Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            'Total Products',
                            stats.totalProducts.toString(),
                            Icons.inventory_2,
                            Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSummaryCard(
                            'Total Users',
                            stats.totalUsers.toString(),
                            Icons.people,
                            Colors.purple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Revenue Chart Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Revenue (This Month)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const RevenueAnalyticsScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.trending_up),
                              label: const Text('Analytics'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RevenueAnalyticsScreen(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            height: 200,
                            child: _buildMiniRevenueChart(
                              dashboardProvider.revenue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Order Stats Chart Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Order Statistics',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const OrderStatisticsScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.pie_chart),
                          label: const Text('Details'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OrderStatisticsScreen(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            height: 200,
                            child: _buildMiniOrderStatsChart(
                              dashboardProvider.orderStatsByStatus,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Top Products
                    const Text(
                      'Top Selling Products',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: dashboardProvider.topProducts.length,
                        itemBuilder: (context, index) {
                          final product = dashboardProvider.topProducts[index];
                          return ListTile(
                            leading: CircleAvatar(child: Text('${index + 1}')),
                            title: Text(product.productName),
                            subtitle: Text('Sold: ${product.totalSold}'),
                            trailing: Text(
                              product.totalRevenue.formatPriceWithCurrency(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniRevenueChart(Map<String, double> revenue) {
    if (revenue.isEmpty) {
      return const Center(child: Text('No revenue data'));
    }

    final entries = revenue.entries.toList();
    final spots = entries.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: AppColors.textMain,
            tooltipRoundedRadius: 8,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  spot.y.formatPrice(),
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.primary,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withOpacity(0.3),
                  AppColors.primary.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniOrderStatsChart(Map<String, int> orderStats) {
    if (orderStats.isEmpty) {
      return const Center(child: Text('No order statistics'));
    }

    final entries = orderStats.entries.toList();
    final total = orderStats.values.fold(0, (sum, value) => sum + value);

    Color getStatusColor(String status) {
      switch (status.toUpperCase()) {
        case 'PENDING':
          return Colors.orange;
        case 'CONFIRMED':
          return Colors.blue;
        case 'SHIPPED':
          return Colors.purple;
        case 'DELIVERED':
          return Colors.green;
        case 'CANCELLED':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return PieChart(
      PieChartData(
        sections: entries.map((entry) {
          final status = entry.key;
          final count = entry.value;
          final percentage = total > 0 ? (count / total * 100) : 0.0;

          return PieChartSectionData(
            value: count.toDouble(),
            title: '${percentage.toStringAsFixed(0)}%',
            color: getStatusColor(status),
            radius: 50,
            titleStyle: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            badgeWidget: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: getStatusColor(status),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            badgePositionPercentageOffset: 1.2,
          );
        }).toList(),
        sectionsSpace: 4,
        centerSpaceRadius: 40,
      ),
    );
  }
}
