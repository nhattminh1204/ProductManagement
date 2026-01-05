import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';

class GetPaymentsByOrderUseCase {
  final PaymentRepository repository;

  GetPaymentsByOrderUseCase(this.repository);

  Future<List<Payment>> execute(int orderId) {
    return repository.getPaymentsByOrderId(orderId);
  }
}

