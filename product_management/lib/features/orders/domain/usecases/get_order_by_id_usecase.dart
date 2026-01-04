import '../repositories/order_repository.dart';
import '../entities/order_entity.dart';

class GetOrderByIdUseCase {
  final OrderRepository repository;
  GetOrderByIdUseCase(this.repository);

  Future<Order> call(int id) {
    return repository.getOrderById(id);
  }
}


