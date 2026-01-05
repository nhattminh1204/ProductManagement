import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';

class GetPaymentsByUserUseCase {
  final PaymentRepository repository;

  GetPaymentsByUserUseCase(this.repository);

  Future<List<Payment>> execute(int userId) {
    return repository.getPaymentsByUserId(userId);
  }
}

