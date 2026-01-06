import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:product_management/product_management/presentation/design_system.dart';
import '../../domain/entities/payment_entity.dart';
import '../../../../core/utils/price_formatter.dart';

class PaymentListItem extends StatelessWidget {
  final Payment payment;
  final int? index;

  const PaymentListItem({super.key, required this.payment, this.index});

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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (index != null) ...[
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${index! + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          'Mã TT: #${payment.id}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        if (payment.paidAt != null)
                          Text(
                             DateFormat('dd/MM/yyyy HH:mm').format(payment.paidAt!),
                             style: TextStyle(color: Colors.grey[500], fontSize: 12),
                          ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(payment.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    payment.status.toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(payment.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                   children: [
                     Icon(Icons.receipt_long_outlined, size: 16, color: Colors.grey[600]),
                     const SizedBox(width: 4),
                     const Text('Đơn hàng:', style: TextStyle(color: Colors.grey)),
                   ],
                ),
                Text(
                  '#${payment.orderId}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
             const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Row(
                   children: [
                     Icon(Icons.payment_outlined, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                     const Text('Phương thức:', style: TextStyle(color: Colors.grey)),
                   ],
                ),
                Text(payment.paymentMethod, style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Row(
                   children: [
                     Icon(Icons.attach_money, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                     const Text('Số tiền:', style: TextStyle(color: Colors.grey)),
                   ],
                ),
                Text(
                  payment.amount.formatPriceWithCurrency(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
