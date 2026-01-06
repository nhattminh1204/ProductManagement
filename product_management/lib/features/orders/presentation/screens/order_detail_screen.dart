import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/order_provider.dart';
import '../../../payments/presentation/providers/payment_provider.dart';
import '../../../../core/utils/price_formatter.dart';
import 'package:product_management/product_management/presentation/design_system.dart';
import '../../domain/entities/order_entity.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().fetchOrderById(widget.orderId);
      context.read<PaymentProvider>().fetchPaymentsByOrder(widget.orderId);
    });
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

  String _getPaymentStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Chờ thanh toán';
      case 'paid':
        return 'Đã thanh toán';
      case 'failed':
        return 'Thất bại';
      default:
        return status;
    }
  }

  Color _getPaymentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'paid':
        return Colors.green;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
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
      // Refresh order details
      context.read<OrderProvider>().fetchOrderById(id);
      // Refresh payment status
      context.read<PaymentProvider>().fetchPaymentsByOrder(id);
    }
  }

  void _cancelOrder(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hủy đơn hàng'),
        content: const Text('Bạn có chắc chắn muốn hủy đơn hàng này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Có'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await context.read<OrderProvider>().cancelOrder(id);
      if (success && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đã hủy đơn hàng thành công')));
        // Refresh order details
        context.read<OrderProvider>().fetchOrderById(id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final paymentProvider = context.watch<PaymentProvider>();
    final order = orderProvider.selectedOrder;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Chi tiết đơn hàng'), centerTitle: true),
      body: orderProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : order == null
              ? Center(
                  child: Text('Lỗi: ${orderProvider.errorMessage ?? "Không tìm thấy đơn hàng"}'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Info Card
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Đơn hàng #${order.orderCode.isNotEmpty ? order.orderCode : order.id}',
                                    style: const TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(order.status)
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      _getStatusText(order.status).toUpperCase(),
                                      style: TextStyle(
                                        color: _getStatusColor(order.status),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow('Ngày đặt',
                                  DateFormat('dd/MM/yyyy HH:mm').format(order.createdDate)),
                              _buildInfoRow('Khách hàng', order.customerName),
                              if (order.email != null) _buildInfoRow('Email', order.email!),
                              if (order.phone != null) _buildInfoRow('Số điện thoại', order.phone!),
                              if (order.address != null)
                                _buildInfoRow('Địa chỉ', order.address!),
                              _buildInfoRow('Phương thức thanh toán', order.paymentMethod ?? 'N/A'),
                              const Divider(),
                              _buildInfoRow('Tổng tiền',
                                  order.totalPrice.formatPriceWithCurrency(),
                                  isBold: true, isPrimary: true),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Order Items
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Danh sách sản phẩm',
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              ...order.items.map((item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(item.productName,
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold)),
                                              Text(
                                                  '${item.quantity} x ${item.price.formatPriceWithCurrency()}'),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          (item.quantity * item.price)
                                              .formatPriceWithCurrency(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Payment Info
                      if (paymentProvider.payments.isNotEmpty)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Thông tin thanh toán',
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 12),
                                ...paymentProvider.payments.map((payment) => Container(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.withValues(alpha: 0.1),
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Thanh toán #${payment.id}',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                payment.amount
                                                    .formatPriceWithCurrency(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Text('Trạng thái: '),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: _getPaymentStatusColor(
                                                          payment.status)
                                                      .withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  _getPaymentStatusText(
                                                      payment.status),
                                                  style: TextStyle(
                                                    color: _getPaymentStatusColor(
                                                        payment.status),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                              'Phương thức: ${payment.paymentMethod}'),
                                          if (payment.paidAt != null)
                                            Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: Text(
                                                'Thời gian: ${DateFormat('dd/MM/yyyy HH:mm').format(payment.paidAt!)}',
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 12),
                                              ),
                                            ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      // Actions
                      if (context.read<AuthProvider>().isAdmin)
                        Column(
                          children: [
                            if (order.status.toLowerCase() == 'pending')
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => _cancelOrder(order.id),
                                      icon: const Icon(Icons.close, color: Colors.red),
                                      label: const Text('Hủy đơn', style: TextStyle(color: Colors.red)),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Colors.red),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: FilledButton.icon(
                                      onPressed: () => _updateStatus(order.id, 'confirmed'),
                                      icon: const Icon(Icons.check),
                                      label: const Text('Duyệt đơn'),
                                      style: FilledButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (order.status.toLowerCase() == 'confirmed' ||
                                order.status.toLowerCase() == 'paid')
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  onPressed: () => _updateStatus(order.id, 'shipped'),
                                  icon: const Icon(Icons.local_shipping),
                                  label: const Text('Bắt đầu giao hàng'),
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                            if (order.status.toLowerCase() == 'shipped')
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  onPressed: () => _updateStatus(order.id, 'delivered'),
                                  icon: const Icon(Icons.check_circle),
                                  label: const Text('Xác nhận đã giao hàng'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            if (order.status.toLowerCase() == 'pending')
                              ElevatedButton(
                                onPressed: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Hủy đơn hàng'),
                                      content: const Text(
                                          'Bạn có chắc chắn muốn hủy đơn hàng này không?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text('Không'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text('Có'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirmed == true) {
                                    await orderProvider.cancelOrder(order.id);
                                    if (mounted) Navigator.pop(context);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 48),
                                ),
                                child: const Text('Hủy đơn hàng'),
                              ),
                            if (order.status.toLowerCase() == 'shipped')
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  onPressed: () async {
                                      final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Xác nhận đã nhận hàng'),
                                        content: const Text(
                                            'Bạn xác nhận đã nhận được đầy đủ hàng và muốn hoàn tất đơn hàng này?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text('Hủy'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text('Đồng ý'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if(confirmed == true) {
                                      _updateStatus(order.id, 'delivered');
                                    }
                                  },
                                  icon: const Icon(Icons.check_circle_outline),
                                  label: const Text('Đã nhận được hàng'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {bool isBold = false, bool isPrimary = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: isBold ? 18 : 16,
                color: isPrimary ? AppColors.primary : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

