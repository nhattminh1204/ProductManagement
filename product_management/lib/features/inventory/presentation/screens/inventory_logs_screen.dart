import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/inventory_provider.dart';
import '../../../../product_management/presentation/design_system.dart';

class InventoryLogsScreen extends StatefulWidget {
  const InventoryLogsScreen({super.key});

  @override
  State<InventoryLogsScreen> createState() => _InventoryLogsScreenState();
}

class _InventoryLogsScreenState extends State<InventoryLogsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<InventoryProvider>().fetchLogs();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InventoryProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Inventory Logs'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.errorMessage != null
            ? Center(child: Text('Error: ${provider.errorMessage}'))
            : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: provider.logs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final log = provider.logs[index];
                  final type = log.logType.toLowerCase();
                  
                  Color bgColor;
                  Color textColor;
                  String label;

                  if (type == 'import') {
                    bgColor = const Color(0xFFDCFCE7); // Green 100
                    textColor = const Color(0xFF166534); // Green 800
                    label = 'Nhập kho';
                  } else if (type == 'adjustment') {
                    bgColor = const Color(0xFFFEF3C7); // Amber 100
                    textColor = const Color(0xFF92400E); // Amber 800
                    label = 'Điều chỉnh';
                  } else {
                    bgColor = const Color(0xFFFEE2E2); // Red 100
                    textColor = const Color(0xFF991B1B); // Red 800
                    label = 'Xuất kho';
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppDimensions.radius),
                      border: Border.all(color: AppColors.border),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon Circle
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.inventory_2_outlined,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Product #${log.productId}',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: AppColors.textMain,
                                    ),
                                  ),
                                  // Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: bgColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      label,
                                      style: GoogleFonts.inter(
                                        color: textColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Thay đổi: ',
                                    style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 13),
                                  ),
                                  Text(
                                    '${log.changeQuantity > 0 ? '+' : ''}${log.changeQuantity}',
                                    style: GoogleFonts.inter(
                                      color: log.changeQuantity > 0 ? AppColors.success : AppColors.error,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              if (log.notes != null && log.notes!.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  log.notes!,
                                  style: GoogleFonts.inter(
                                    color: AppColors.textLight,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 8),
                              Text(
                                DateFormat('dd/MM/yyyy HH:mm').format(log.createdAt),
                                style: GoogleFonts.inter(
                                  color: AppColors.textLight,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
