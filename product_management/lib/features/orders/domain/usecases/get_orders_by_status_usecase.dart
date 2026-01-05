import '../repositories/order_repository.dart';
import '../entities/order_entity.dart';

class GetOrdersByStatusUseCase {
  final OrderRepository repository;
  GetOrdersByStatusUseCase(this.repository);

  Future<List<Order>> call(String status) {
    return repository.getOrdersByStatus(status);
  }
}

