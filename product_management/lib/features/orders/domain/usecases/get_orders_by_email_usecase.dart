import '../repositories/order_repository.dart';
import '../entities/order_entity.dart';

class GetOrdersByEmailUseCase {
  final OrderRepository repository;
  GetOrdersByEmailUseCase(this.repository);

  Future<List<Order>> call(String email) {
    return repository.getOrdersByEmail(email);
  }
}


