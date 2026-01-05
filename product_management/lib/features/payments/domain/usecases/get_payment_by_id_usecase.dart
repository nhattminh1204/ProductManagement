import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';

class GetPaymentByIdUseCase {
  final PaymentRepository repository;

  GetPaymentByIdUseCase(this.repository);

  Future<Payment> execute(int id) {
    return repository.getPaymentById(id);
  }
}

