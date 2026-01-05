import '../repositories/order_repository.dart';
import '../entities/order_entity.dart';

class GetOrdersByUserIdUseCase {
  final OrderRepository repository;
  GetOrdersByUserIdUseCase(this.repository);

  Future<List<Order>> call(int userId) {
    return repository.getOrdersByUserId(userId);
  }
}

