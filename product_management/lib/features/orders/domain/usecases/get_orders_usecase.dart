import '../repositories/order_repository.dart';
import '../entities/order_entity.dart';

class GetOrdersUseCase {
  final OrderRepository repository;
  GetOrdersUseCase(this.repository);

  Future<List<Order>> call() {
    return repository.getOrders();
  }
}


