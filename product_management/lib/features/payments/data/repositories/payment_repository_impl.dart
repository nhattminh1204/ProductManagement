import '../../../../api/api_service.dart';
import '../models/payment_model.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final ApiService _apiService;
  PaymentRepositoryImpl(this._apiService);

  @override
  Future<Payment> createPayment(int orderId, double amount, String paymentMethod) async {
    final model = await _apiService.createPayment(orderId, amount, paymentMethod);
    return _toEntity(model);
  }

  @override
  Future<Payment> getPaymentById(int id) async {
    final model = await _apiService.getPaymentById(id);
    return _toEntity(model);
  }

  @override
  Future<List<Payment>> getPaymentsByOrderId(int orderId) async {
    final models = await _apiService.getPaymentsByOrderId(orderId);
    return models.map((m) => _toEntity(m)).toList();
  }

  @override
  Future<List<Payment>> getPaymentsByUserId(int userId) async {
    final models = await _apiService.getPaymentsByUserId(userId);
    return models.map((m) => _toEntity(m)).toList();
  }

  @override
  Future<List<Payment>> getAllPayments() async {
    final models = await _apiService.getAllPayments();
    return models.map((m) => _toEntity(m)).toList();
  }

  @override
  Future<Payment> updatePaymentStatus(int id, String status) async {
    final model = await _apiService.updatePaymentStatus(id, status);
    return _toEntity(model);
  }

  Payment _toEntity(PaymentModel model) {
    return Payment(
      id: model.id,
      orderId: model.orderId,
      amount: model.amount,
      paymentMethod: model.paymentMethod,
      status: model.status,
      paidAt: model.paidAt,
    );
  }
}

