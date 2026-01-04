import '../repositories/order_repository.dart';

class UpdateOrderStatusUseCase {
  final OrderRepository repository;
  UpdateOrderStatusUseCase(this.repository);

  Future<void> call(int id, String status) {
    return repository.updateOrderStatus(id, status);
  }
}


