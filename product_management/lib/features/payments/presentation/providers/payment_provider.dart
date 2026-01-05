import 'package:flutter/foundation.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/usecases/create_payment_usecase.dart';
import '../../domain/usecases/get_payment_by_id_usecase.dart';
import '../../domain/usecases/get_payments_by_order_usecase.dart';
import '../../domain/usecases/get_payments_by_user_usecase.dart';
import '../../domain/usecases/update_payment_status_usecase.dart';

class PaymentProvider extends ChangeNotifier {
  final CreatePaymentUseCase createPaymentUseCase;
  final GetPaymentByIdUseCase getPaymentByIdUseCase;
  final GetPaymentsByOrderUseCase getPaymentsByOrderUseCase;
  final GetPaymentsByUserUseCase getPaymentsByUserUseCase;
  final UpdatePaymentStatusUseCase updatePaymentStatusUseCase;

  PaymentProvider(
    this.createPaymentUseCase,
    this.getPaymentByIdUseCase,
    this.getPaymentsByOrderUseCase,
    this.getPaymentsByUserUseCase,
    this.updatePaymentStatusUseCase,
  );

  List<Payment> _payments = [];
  Payment? _selectedPayment;
  bool _isLoading = false;
  String? _error;

  List<Payment> get payments => _payments;
  Payment? get selectedPayment => _selectedPayment;
  bool get isLoading => _isLoading;
  String? get error => _error;

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

  Future<bool> createPayment(int orderId, double amount, String paymentMethod) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final payment = await createPaymentUseCase.execute(orderId, amount, paymentMethod);
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
      final updatedPayment = await updatePaymentStatusUseCase.execute(id, status);
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

