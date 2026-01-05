import 'package:flutter/foundation.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/usecases/create_payment_usecase.dart';
import '../../domain/usecases/get_payment_by_id_usecase.dart';
import '../../domain/usecases/get_payments_by_order_usecase.dart';
import '../../domain/usecases/get_payments_by_user_usecase.dart';
import '../../domain/usecases/update_payment_status_usecase.dart';

import '../../domain/usecases/get_all_payments_usecase.dart';

class PaymentProvider extends ChangeNotifier {
  final CreatePaymentUseCase createPaymentUseCase;
  final GetPaymentByIdUseCase getPaymentByIdUseCase;
  final GetPaymentsByOrderUseCase getPaymentsByOrderUseCase;
  final GetPaymentsByUserUseCase getPaymentsByUserUseCase;
  final UpdatePaymentStatusUseCase updatePaymentStatusUseCase;
  final GetAllPaymentsUseCase getAllPaymentsUseCase;

  PaymentProvider(
    this.createPaymentUseCase,
    this.getPaymentByIdUseCase,
    this.getPaymentsByOrderUseCase,
    this.getPaymentsByUserUseCase,
    this.updatePaymentStatusUseCase,
    this.getAllPaymentsUseCase,
  );

  List<Payment> _payments = [];
  List<Payment> _allPayments = []; // for filtering
  Payment? _selectedPayment;
  bool _isLoading = false;
  String? _error;

  // Filters
  String? _filterStatus;
  String? _filterMethod;
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;
  String? _searchQuery;

  List<Payment> get payments => _payments;
  Payment? get selectedPayment => _selectedPayment;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Filter getters
  String? get filterStatus => _filterStatus;
  String? get filterMethod => _filterMethod;
  DateTime? get filterStartDate => _filterStartDate;
  DateTime? get filterEndDate => _filterEndDate;
  String? get searchQuery => _searchQuery;

  Future<void> fetchAllPayments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allPayments = await getAllPaymentsUseCase.execute();
      _payments = _allPayments;
      _applyFilters();
    } catch (e) {
      _error = e.toString();
      _payments = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFilters({
    String? status,
    String? method,
    DateTime? startDate,
    DateTime? endDate,
    String? query,
  }) {
    _filterStatus = status;
    _filterMethod = method;
    _filterStartDate = startDate;
    _filterEndDate = endDate;
    if (query != null) {
      _searchQuery = query;
    }
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _filterStatus = null;
    _filterMethod = null;
    _filterStartDate = null;
    _filterEndDate = null;
    _searchQuery = null;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _payments = _allPayments.where((payment) {
      // Status
      if (_filterStatus != null &&
          payment.status.toLowerCase() != _filterStatus!.toLowerCase()) {
        return false;
      }

      // Method
      if (_filterMethod != null &&
          payment.paymentMethod.toLowerCase() != _filterMethod!.toLowerCase()) {
        return false;
      }

      // Date Range
      if (_filterStartDate != null) {
        final date = payment.paidAt;
        if (date == null || date.isBefore(_filterStartDate!)) return false;
      }
      if (_filterEndDate != null) {
        final date = payment.paidAt;
        // End date should be end of day
        final endOfDay = DateTime(
          _filterEndDate!.year,
          _filterEndDate!.month,
          _filterEndDate!.day,
          23,
          59,
          59,
        );
        if (date == null || date.isAfter(endOfDay)) return false;
      }

      // Search (OrderId or PaymentId)
      if (_searchQuery != null && _searchQuery!.isNotEmpty) {
        final query = _searchQuery!.toLowerCase();
        final matchesId = payment.id.toString().contains(query);
        final matchesOrderId = payment.orderId.toString().contains(query);
        if (!matchesId && !matchesOrderId) return false;
      }

      return true;
    }).toList();

    _payments.sort((a, b) {
      if (a.paidAt == null && b.paidAt == null) return 0;
      if (a.paidAt == null) return 1;
      if (b.paidAt == null) return -1;
      return b.paidAt!.compareTo(a.paidAt!);
    });
  }

  Future<void> fetchPaymentsByUser(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _payments = await getPaymentsByUserUseCase.execute(userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _payments = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPaymentsByOrder(int orderId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _payments = await getPaymentsByOrderUseCase.execute(orderId);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _payments = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPaymentById(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedPayment = await getPaymentByIdUseCase.execute(id);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _selectedPayment = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createPayment(
    int orderId,
    double amount,
    String paymentMethod,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final payment = await createPaymentUseCase.execute(
        orderId,
        amount,
        paymentMethod,
      );
      _payments.add(payment);
      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateStatus(int id, String status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedPayment = await updatePaymentStatusUseCase.execute(
        id,
        status,
      );
      final index = _payments.indexWhere((p) => p.id == id);
      if (index != -1) {
        _payments[index] = updatedPayment;
      }
      if (_selectedPayment?.id == id) {
        _selectedPayment = updatedPayment;
      }
      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
