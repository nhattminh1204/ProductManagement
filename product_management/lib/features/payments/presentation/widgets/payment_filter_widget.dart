import 'package:flutter/material.dart';
import 'package:product_management/product_management/presentation/design_system.dart';

class PaymentFilterWidget extends StatefulWidget {
  final String? initialStatus;
  final String? initialMethod;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(String? status, String? method, DateTime? startDate, DateTime? endDate) onApply;
  final VoidCallback onClear;

  const PaymentFilterWidget({
    super.key,
    this.initialStatus,
    this.initialMethod,
    this.initialStartDate,
    this.initialEndDate,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<PaymentFilterWidget> createState() => _PaymentFilterWidgetState();
}

class _PaymentFilterWidgetState extends State<PaymentFilterWidget> {
  String? _selectedStatus;
  String? _selectedMethod;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialStatus;
    _selectedMethod = widget.initialMethod;
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(picked)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bộ lọc thanh toán',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Trạng thái',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Pending', 'Paid', 'Failed'].map((status) {
                final isSelected = _selectedStatus?.toLowerCase() == status.toLowerCase();
                return ChoiceChip(
                  label: Text(status),
                  selected: isSelected,
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : Colors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedStatus = selected ? status : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Phương thức',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['COD', 'Bank Transfer', 'Credit Card'].map((method) {
                 final isSelected = _selectedMethod?.toLowerCase() == method.toLowerCase();
                return ChoiceChip(
                  label: Text(method),
                  selected: isSelected,
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                   labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : Colors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedMethod = selected ? method : null;
                    });
                  },
                );
              }).toList(),
            ),
             const SizedBox(height: 16),
            const Text(
              'Khoảng thời gian',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(context, true),
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(
                      _startDate != null
                          ? _startDate!.toString().split(' ')[0]
                          : 'Từ ngày',
                       style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(context, false),
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(
                      _endDate != null
                          ? _endDate!.toString().split(' ')[0]
                          : 'Đến ngày',
                       style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      widget.onClear();
                      Navigator.pop(context);
                    },
                    child: const Text('Xóa bộ lọc'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      widget.onApply(_selectedStatus, _selectedMethod, _startDate, _endDate);
                      Navigator.pop(context);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('Áp dụng'),
                  ),
                ),
              ],
            ),
             const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
