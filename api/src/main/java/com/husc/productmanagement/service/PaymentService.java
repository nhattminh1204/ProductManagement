package com.husc.productmanagement.service;

import com.husc.productmanagement.dto.PaymentDTO;
import com.husc.productmanagement.dto.PaymentRequest;
import com.husc.productmanagement.entity.Order;
import com.husc.productmanagement.entity.Payment;
import com.husc.productmanagement.repository.OrderRepository;
import com.husc.productmanagement.repository.PaymentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PaymentService {

    private final PaymentRepository paymentRepository;
    private final OrderRepository orderRepository;

    @Transactional
    public PaymentDTO createPayment(Integer orderId, PaymentRequest request) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found with id: " + orderId));

        Payment payment = new Payment();
        payment.setOrder(order);
        payment.setAmount(request.getAmount());
        payment.setPaymentMethod(request.getPaymentMethod());
        
        if (request.getStatus() != null && !request.getStatus().isEmpty()) {
            payment.setStatus(Payment.Status.fromValue(request.getStatus()));
        } else {
            payment.setStatus(Payment.Status.PENDING);
        }

        Payment savedPayment = paymentRepository.save(payment);
        return convertToDTO(savedPayment);
    }

    @Transactional(readOnly = true)
    public PaymentDTO getPaymentById(Integer id) {
        Payment payment = paymentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Payment not found with id: " + id));
        return convertToDTO(payment);
    }

    @Transactional(readOnly = true)
    public List<PaymentDTO> getPaymentsByOrderId(Integer orderId) {
        return paymentRepository.findByOrderId(orderId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<PaymentDTO> getPaymentsByUserId(Integer userId) {
        // Get all orders for the user, then get payments for those orders
        List<Order> userOrders = orderRepository.findByUserId(userId);
        return userOrders.stream()
                .flatMap(order -> paymentRepository.findByOrderId(order.getId()).stream())
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<PaymentDTO> getAllPayments() {
        return paymentRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public PaymentDTO updatePaymentStatus(Integer id, String status) {
        Payment payment = paymentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Payment not found with id: " + id));

        Payment.Status newStatus = Payment.Status.fromValue(status);
        payment.setStatus(newStatus);

        if (newStatus == Payment.Status.PAID && payment.getPaidAt() == null) {
            payment.setPaidAt(LocalDateTime.now());
        }

        Payment updatedPayment = paymentRepository.save(payment);
        return convertToDTO(updatedPayment);
    }

    @Transactional
    public PaymentDTO processPayment(Integer orderId, PaymentRequest request) {
        // Create payment
        PaymentDTO payment = createPayment(orderId, request);

        // If payment status is PAID, update order status
        if (request.getStatus() != null && 
            (request.getStatus().equalsIgnoreCase("paid") || 
             Payment.Status.fromValue(request.getStatus()) == Payment.Status.PAID)) {
            Order order = orderRepository.findById(orderId)
                    .orElseThrow(() -> new RuntimeException("Order not found with id: " + orderId));
            order.setStatus(Order.Status.PAID);
            orderRepository.save(order);
        }

        return payment;
    }

    private PaymentDTO convertToDTO(Payment payment) {
        PaymentDTO dto = new PaymentDTO();
        dto.setId(payment.getId());
        dto.setOrderId(payment.getOrder().getId());
        dto.setAmount(payment.getAmount());
        dto.setPaymentMethod(payment.getPaymentMethod());
        dto.setStatus(payment.getStatus().getValue());
        dto.setPaidAt(payment.getPaidAt());
        return dto;
    }
}

