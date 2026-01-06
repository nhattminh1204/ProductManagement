import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/payment_provider.dart';
import '../../../../core/utils/price_formatter.dart';
import 'package:product_management/product_management/presentation/design_system.dart';
import 'payment_detail_screen.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().userId;
      if (userId != null) {
        context.read<PaymentProvider>().fetchPaymentsByUser(userId);
      }
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = context.watch<PaymentProvider>();
    final userId = context.watch<AuthProvider>().userId;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Payment History')),
        body: const Center(child: Text('Please login to view payment history')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Lịch sử thanh toán'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: paymentProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : paymentProvider.error != null
              ? Center(child: Text('Lỗi: ${paymentProvider.error}'))
              : paymentProvider.payments.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.payment, size: 80, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text('Chưa có thanh toán nào',
                              style: TextStyle(color: Colors.grey[600], fontSize: 18)),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await paymentProvider.fetchPaymentsByUser(userId);
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: paymentProvider.payments.length,
                        itemBuilder: (context, index) {
                          final payment = paymentProvider.payments[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: Icon(Icons.payment,
                                  color: _getStatusColor(payment.status)),
                              title: Text('Đơn hàng #${payment.orderId}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    payment.amount.formatPriceWithCurrency(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary),
                                  ),
                                  if (payment.paidAt != null)
                                    Text(
                                      DateFormat('MMM dd, yyyy HH:mm')
                                          .format(payment.paidAt!),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey[600]),
                                    ),
                                ],
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(payment.status)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  payment.status.toUpperCase(),
                                  style: TextStyle(
                                    color: _getStatusColor(payment.status),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PaymentDetailScreen(
                                        paymentId: payment.id!),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}

