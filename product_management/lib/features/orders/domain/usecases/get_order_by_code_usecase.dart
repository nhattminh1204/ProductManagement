import '../repositories/order_repository.dart';
import '../entities/order_entity.dart';

class GetOrderByCodeUseCase {
  final OrderRepository repository;
  GetOrderByCodeUseCase(this.repository);

  Future<Order> call(String code) {
    return repository.getOrderByCode(code);
  }
}


