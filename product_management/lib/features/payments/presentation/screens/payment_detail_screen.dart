import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/payment_provider.dart';
import '../../../../core/utils/price_formatter.dart';
import 'package:product_management/product_management/presentation/design_system.dart';

class PaymentDetailScreen extends StatefulWidget {
  final int paymentId;

  const PaymentDetailScreen({super.key, required this.paymentId});

  @override
  State<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentProvider>().fetchPaymentById(widget.paymentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = context.watch<PaymentProvider>();
    final payment = paymentProvider.selectedPayment;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Chi tiết thanh toán'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: paymentProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : payment == null
              ? Center(child: Text('Lỗi: ${paymentProvider.error ?? "Không tìm thấy thanh toán"}'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow('Mã thanh toán', '#${payment.id}'),
                          _buildDetailRow('Mã đơn hàng', '#${payment.orderId}'),
                          _buildDetailRow('Số tiền',
                              payment.amount.formatPriceWithCurrency()),
                          _buildDetailRow('Phương thức', payment.paymentMethod),
                          _buildDetailRow('Trạng thái', payment.status.toUpperCase()),
                          if (payment.paidAt != null)
                            _buildDetailRow('Thời gian thanh toán',
                                DateFormat('dd/MM/yyyy HH:mm').format(payment.paidAt!)),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

