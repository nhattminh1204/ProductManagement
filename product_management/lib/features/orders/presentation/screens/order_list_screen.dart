import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/order_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/screens/login_screen.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

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
    final success = await context.read<OrderProvider>().updateOrderStatus(id, status);
    if (success && mounted) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Status updated')));
    }
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
      appBar: AppBar(title: const Text('Orders')),
      body: orderProvider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : orderProvider.orders.isEmpty
           ? const Center(child: Text('No orders found'))
           : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: orderProvider.orders.length,
              itemBuilder: (context, index) {
                final order = orderProvider.orders[index];
                return Card(
                  child: ExpansionTile(
                    title: Text('#${order.orderCode} - ${order.customerName}'),
                    subtitle: Text(
                      '${DateFormat('yyyy-MM-dd HH:mm').format(order.createdDate)} - \$${order.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800]),
                    ),
                    trailing: PopupMenuButton<String>(
                      initialValue: order.status,
                      onSelected: (val) => _updateStatus(order.id, val),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.status).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _getStatusColor(order.status)),
                        ),
                        child: Text(
                          order.status,
                          style: TextStyle(color: _getStatusColor(order.status), fontWeight: FontWeight.bold),
                        ),
                      ),
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'pending', child: Text('Pending')),
                        const PopupMenuItem(value: 'paid', child: Text('Paid')),
                        const PopupMenuItem(value: 'shipped', child: Text('Shipped')),
                        const PopupMenuItem(value: 'cancelled', child: Text('Cancelled')),
                      ],
                    ),
                    children: order.items.map((item) {
                      return ListTile(
                        title: Text(item.productName),
                        trailing: Text('${item.quantity} x \$${item.price.toStringAsFixed(2)}'),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
    );
  }
}


