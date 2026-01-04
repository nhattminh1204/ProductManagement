import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/price_formatter.dart';
import '../providers/order_provider.dart';
import '../providers/auth_provider.dart';
import '../design_system.dart';

class UserOrderHistoryScreen extends StatefulWidget {
  const UserOrderHistoryScreen({super.key});

  @override
  State<UserOrderHistoryScreen> createState() => _UserOrderHistoryScreenState();
}

class _UserOrderHistoryScreenState extends State<UserOrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final email = context.read<AuthProvider>().userEmail;
      if (email != null) {
        context.read<OrderProvider>().fetchOrdersByEmail(email);
      }
    });
  }

  Color _getStatusColor(String status) {
    switch(status.toLowerCase()) {
      case 'pending': return Colors.orange;
      case 'paid': return Colors.blue;
      case 'shipped': return Colors.green;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('My Orders')),
      body: orderProvider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : orderProvider.errorMessage != null
          ? Center(child: Text('Error: ${orderProvider.errorMessage}'))
          : orderProvider.orders.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history_rounded, size: 80, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text('No orders yet', style: TextStyle(color: Colors.grey[600], fontSize: 18)),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  final email = context.read<AuthProvider>().userEmail;
                  if (email != null) {
                    await context.read<OrderProvider>().fetchOrdersByEmail(email);
                  }
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: orderProvider.orders.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final order = orderProvider.orders[index];
                    return Container(
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
                      ),
                      child: ExpansionTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        backgroundColor: Colors.white,
                        collapsedBackgroundColor: Colors.white,
                        title: Row(
                          children: [
                            Text(
                              order.orderCode.isNotEmpty ? '#${order.orderCode} ' : '#${order.id} ',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(order.status).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                order.status.toUpperCase(),
                                style: TextStyle(
                                  color: _getStatusColor(order.status),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('MMM dd, yyyy HH:mm').format(order.createdDate),
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              order.totalPrice.formatPriceWithCurrency(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        children: [
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                ...order.items.map((item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                       Container(
                                          width: 40,
                                          height: 40,
                                          margin: const EdgeInsets.only(right: 12),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.circular(8),
                                            image: item.productImage != null && item.productImage!.isNotEmpty
                                                ? DecorationImage(image: NetworkImage(item.productImage!), fit: BoxFit.cover)
                                                : null,
                                          ),
                                          child: item.productImage == null || item.productImage!.isEmpty
                                            ? const Icon(Icons.image_not_supported, size: 20, color: Colors.grey)
                                            : null,
                                        ),
                                      Expanded(child: Text(item.productName)),
                                      Text('${item.quantity} x ${item.price.formatPriceWithCurrency()}'),
                                    ],
                                  ),
                                )),
                                const SizedBox(height: 12),
                                const Divider(),
                                const SizedBox(height: 8),
                                const Text('Delivery to:', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(order.customerName),
                                if (order.address != null) Text(order.address!),
                                if (order.phone != null) Text(order.phone!),

                                if (order.status.toLowerCase() == 'pending') ...[
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Cancel Order?'),
                                            content: const Text(
                                                'Are you sure you want to cancel this order? This action cannot be undone.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('No, Keep Order'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  final success = await context.read<OrderProvider>().cancelOrder(order.id);
                                                  if (mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text(success 
                                                            ? 'Order cancelled successfully' 
                                                            : 'Failed to cancel order'),
                                                        backgroundColor: success ? Colors.green : Colors.red,
                                                        behavior: SnackBarBehavior.floating,
                                                      ),
                                                    );
                                                  }
                                                },
                                                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                                                child: const Text('Yes, Cancel Order'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.cancel_outlined, color: AppColors.error),
                                      label: const Text('Cancel Order'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColors.error,
                                        side: const BorderSide(color: AppColors.error),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
