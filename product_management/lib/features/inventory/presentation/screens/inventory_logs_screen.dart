import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
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
                padding: const EdgeInsets.all(16),
                itemCount: provider.logs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final log = provider.logs[index];
                  final isImport = log.logType.toLowerCase() == 'import';
                  final isAdjustment = log.logType.toLowerCase() == 'adjustment';
                  
                  Color color = isImport ? Colors.green : (isAdjustment ? Colors.orange : Colors.red);
                  IconData icon = isImport ? Icons.download : (isAdjustment ? Icons.tune : Icons.upload);

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                         BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: color.withValues(alpha: 0.1),
                        child: Icon(icon, color: color),
                      ),
                      title: Text(
                        'Product ID: ${log.productId}', 
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('${log.logType.toUpperCase()} - Change: ${log.changeQuantity}'),
                          if (log.notes != null && log.notes!.isNotEmpty) 
                            Text('Note: ${log.notes!}', style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic)),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('yyyy-MM-dd HH:mm').format(log.createdAt), 
                            style: TextStyle(color: Colors.grey[400], fontSize: 12),
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
