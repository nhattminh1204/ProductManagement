import '../entities/payment_entity.dart';
import '../repositories/payment_repository.dart';

class GetAllPaymentsUseCase {
  final PaymentRepository repository;

  GetAllPaymentsUseCase(this.repository);

  Future<List<Payment>> execute() {
    return repository.getAllPayments();
  }
}
