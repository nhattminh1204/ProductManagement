import '../repositories/order_repository.dart';
import '../entities/order_entity.dart';

class CreateOrderUseCase {
  final OrderRepository repository;
  CreateOrderUseCase(this.repository);

  Future<Order> call(Order order) {
    return repository.createOrder(order);
  }
}


