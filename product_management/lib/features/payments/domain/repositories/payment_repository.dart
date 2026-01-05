import '../../domain/entities/payment_entity.dart';

abstract class PaymentRepository {
  Future<Payment> createPayment(int orderId, double amount, String paymentMethod);
  Future<Payment> getPaymentById(int id);
  Future<List<Payment>> getPaymentsByOrderId(int orderId);
  Future<List<Payment>> getPaymentsByUserId(int userId);
  Future<List<Payment>> getAllPayments();
  Future<Payment> updatePaymentStatus(int id, String status);
}

