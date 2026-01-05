import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';

class UpdatePaymentStatusUseCase {
  final PaymentRepository repository;

  UpdatePaymentStatusUseCase(this.repository);

  Future<Payment> execute(int id, String status) {
    return repository.updatePaymentStatus(id, status);
  }
}

