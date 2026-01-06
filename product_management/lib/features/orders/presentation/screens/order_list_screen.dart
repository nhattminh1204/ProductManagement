import 'package:flutter/material.dart';
import 'package:product_management/product_management/presentation/design_system.dart';

import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/price_formatter.dart';
import '../providers/order_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import 'order_detail_screen.dart';
import '../widgets/order_filter_bottom_sheet.dart';


class OrderListScreen extends StatefulWidget {
  final VoidCallback? onOpenDrawer;

  const OrderListScreen({super.key, this.onOpenDrawer});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (!authProvider.isAdmin) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Access Denied: Admin privileges required.'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      } else {
        context.read<OrderProvider>().fetchOrders();
      }
    });
  }

  void _updateStatus(int id, String status) async {
    final success = await context.read<OrderProvider>().updateOrderStatus(
      id,
      status,
    );
    if (success && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cập nhật trạng thái thành công')));
    }
  }

  void _cancelOrder(int id) async {
    final success = await context.read<OrderProvider>().cancelOrder(id);
    if (success && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã hủy đơn hàng thành công')));
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'paid':
      case 'confirmed':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Chờ xử lý';
      case 'paid':
        return 'Đã thanh toán';
      case 'confirmed':
        return 'Đã xác nhận';
      case 'shipped':
        return 'Đang giao';
      case 'delivered':
        return 'Đã giao';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return status;
    }
  }

  void _showFilterBottomSheet(BuildContext context) {
    final orderProvider = context.read<OrderProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderFilterBottomSheet(
        initialStatus: orderProvider.filterStatus,
        initialStartDate: orderProvider.filterStartDate,
        initialEndDate: orderProvider.filterEndDate,
        onApply: (status, startDate, endDate) {
          orderProvider.setFilters(
            status: status,
            startDate: startDate,
            endDate: endDate,
          );
        },
        onClear: () {
          orderProvider.clearFilters();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => widget.onOpenDrawer?.call(),
          ),
        ),
        title: const Text('Quản lý đơn hàng'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm đơn hàng...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    ),
                    onChanged: (value) {
                      context.read<OrderProvider>().setFilters(query: value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _showFilterBottomSheet(context),
                  icon: const Icon(Icons.filter_list),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: orderProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : orderProvider.orders.isEmpty
          ? const Center(child: Text('Không có đơn hàng nào'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: orderProvider.orders.length,
              itemBuilder: (context, index) {
                final order = orderProvider.orders[index];
                final isPending = order.status.toLowerCase() == 'pending';
                
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '#${order.orderCode}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      DateFormat('dd/MM/yyyy HH:mm').format(order.createdDate),
                                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: _getStatusColor(order.status).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _getStatusText(order.status),
                                style: TextStyle(
                                  color: _getStatusColor(order.status),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded( // Customer info
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.blue.withValues(alpha: 0.1),
                                    child: const Icon(Icons.person, size: 16, color: Colors.blue),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      order.customerName, 
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              order.totalPrice.formatPriceWithCurrency(),
                               style: const TextStyle(
                                 fontWeight: FontWeight.w900, 
                                 color: AppColors.primary,
                                 fontSize: 16,
                                ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => OrderDetailScreen(orderId: order.id),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey[700],
                              ),
                              child: const Text('Chi tiết'),
                            ),
                            if (isPending) ...[
                              const SizedBox(width: 8),
                              OutlinedButton.icon(
                                onPressed: () => _cancelOrder(order.id),
                                icon: const Icon(Icons.close, size: 16, color: Colors.red),
                                label: const Text('Hủy', style: TextStyle(color: Colors.red)),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.red),
                                  foregroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                ),
                              ),
                              const SizedBox(width: 8),
                              FilledButton.icon(
                                onPressed: () => _updateStatus(order.id, 'confirmed'),
                                icon: const Icon(Icons.check, size: 16),
                                label: const Text('Duyệt'),
                                style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16)),
                              ),
                            ] else if (order.status.toLowerCase() == 'confirmed' || order.status.toLowerCase() == 'paid') ...[
                              const SizedBox(width: 8),
                              FilledButton.icon(
                                onPressed: () => _updateStatus(order.id, 'shipped'),
                                icon: const Icon(Icons.local_shipping, size: 16),
                                label: const Text('Giao hàng'),
                                style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16)),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
