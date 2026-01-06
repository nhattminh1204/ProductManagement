import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/payment_provider.dart';
import 'package:product_management/product_management/presentation/design_system.dart';

class PaymentManagementScreen extends StatelessWidget {
  const PaymentManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentProvider = context.watch<PaymentProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Payment Management'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: paymentProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : paymentProvider.error != null
              ? Center(child: Text('Error: ${paymentProvider.error}'))
              : const Center(
                  child: Text('Payment Management - Admin View\n(To be implemented)'),
                ),
    );
  }
}

