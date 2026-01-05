import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';

class CreatePaymentUseCase {
  final PaymentRepository repository;

  CreatePaymentUseCase(this.repository);

  Future<Payment> execute(int orderId, double amount, String paymentMethod) {
    return repository.createPayment(orderId, amount, paymentMethod);
  }
}

