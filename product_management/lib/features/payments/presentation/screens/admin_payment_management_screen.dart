import 'package:flutter/material.dart';
import 'package:product_management/features/shared/design_system.dart';
import 'package:product_management/features/shared/presentation/widgets/admin_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/payment_provider.dart';
import '../widgets/payment_filter_widget.dart';
import '../widgets/payment_list_item.dart';

class AdminPaymentManagementScreen extends StatefulWidget {
  const AdminPaymentManagementScreen({super.key});

  @override
  State<AdminPaymentManagementScreen> createState() =>
      _AdminPaymentManagementScreenState();
}

class _AdminPaymentManagementScreenState
    extends State<AdminPaymentManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentProvider>().fetchAllPayments();
    });
  }

  void _showFilter(BuildContext context) {
    final provider = context.read<PaymentProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentFilterWidget(
        initialStatus: provider.filterStatus,
        initialMethod: provider.filterMethod,
        initialStartDate: provider.filterStartDate,
        initialEndDate: provider.filterEndDate,
        onApply: (status, method, startDate, endDate) {
          provider.setFilters(
            status: status,
            method: method,
            startDate: startDate,
            endDate: endDate,
          );
        },
        onClear: () {
          provider.clearFilters();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentProvider>();

    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(
        title: const Text('Quản lý thanh toán'),
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
                      hintText: 'Tìm theo Order ID, Payment ID...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                    ),
                    onChanged: (value) {
                      provider.setFilters(query: value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _showFilter(context),
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
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.payments.isEmpty
          ? const Center(child: Text('Không có giao dịch thanh toán nào'))
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              itemCount: provider.payments.length,
              itemBuilder: (context, index) {
                final payment = provider.payments[index];
                return PaymentListItem(payment: payment);
              },
            ),
    );
  }
}
