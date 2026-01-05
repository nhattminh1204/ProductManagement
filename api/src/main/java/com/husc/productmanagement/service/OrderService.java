package com.husc.productmanagement.service;

import com.husc.productmanagement.dto.OrderDTO;
import com.husc.productmanagement.dto.OrderItemDTO;
import com.husc.productmanagement.dto.PaymentDTO;
import com.husc.productmanagement.dto.PaymentRequest;
import com.husc.productmanagement.entity.Order;
import com.husc.productmanagement.entity.OrderDetail;
import com.husc.productmanagement.entity.Product;
import com.husc.productmanagement.repository.OrderDetailRepository;
import com.husc.productmanagement.repository.OrderRepository;
import com.husc.productmanagement.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderRepository orderRepository;
    private final OrderDetailRepository orderDetailRepository;
    private final ProductRepository productRepository;
    private final PaymentService paymentService;
    private final com.husc.productmanagement.repository.UserRepository userRepository;

    @Transactional(readOnly = true)
    public List<OrderDTO> getAllOrders() {
        return orderRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public OrderDTO getOrderById(Integer id) {
        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Order not found with id: " + id));
        return convertToDTO(order);
    }

    @Transactional(readOnly = true)
    public OrderDTO getOrderByCode(String orderCode) {
        Order order = orderRepository.findByOrderCode(orderCode)
                .orElseThrow(() -> new RuntimeException("Order not found with code: " + orderCode));
        return convertToDTO(order);
    }

    @Transactional(readOnly = true)
    public List<OrderDTO> getOrdersByEmail(String email) {
        return orderRepository.findByEmail(email).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<OrderDTO> getOrdersByUserId(Integer userId) {
        return orderRepository.findByUserId(userId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<OrderDTO> getOrdersByStatus(String status) {
        Order.Status orderStatus = Order.Status.fromValue(status);
        return orderRepository.findByStatus(orderStatus).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public OrderDTO createOrder(OrderDTO orderDTO) {
        // Generate order code
        String orderCode = generateOrderCode();

        // Create order
        Order order = new Order();
        order.setOrderCode(orderCode);
        order.setCustomerName(orderDTO.getCustomerName());
        order.setEmail(orderDTO.getEmail());
        order.setPhone(orderDTO.getPhone());
        order.setAddress(orderDTO.getAddress());
        order.setPaymentMethod(orderDTO.getPaymentMethod());
        order.setStatus(Order.Status.PENDING);

        if (orderDTO.getUserId() != null) {
            com.husc.productmanagement.entity.User user = userRepository.findById(orderDTO.getUserId())
                    .orElseThrow(() -> new RuntimeException("User not found with id: " + orderDTO.getUserId()));
            order.setUser(user);
        }

        // Calculate total and create order details
        BigDecimal totalAmount = BigDecimal.ZERO;
        List<OrderDetail> orderDetails = new ArrayList<>();

        for (OrderItemDTO itemDTO : orderDTO.getItems()) {
            Product product = productRepository.findById(itemDTO.getProductId())
                    .orElseThrow(() -> new RuntimeException("Product not found with id: " + itemDTO.getProductId()));

            // Check stock
            if (product.getQuantity() < itemDTO.getQuantity()) {
                throw new RuntimeException("Insufficient stock for product: " + product.getName());
            }

            // Create order detail
            OrderDetail detail = new OrderDetail();
            detail.setOrder(order);
            detail.setProduct(product);
            detail.setQuantity(itemDTO.getQuantity());
            detail.setPrice(product.getPrice());
            detail.setSubtotal(product.getPrice().multiply(new BigDecimal(itemDTO.getQuantity())));

            orderDetails.add(detail);
            totalAmount = totalAmount.add(detail.getSubtotal());

            // Update product quantity
            product.setQuantity(product.getQuantity() - itemDTO.getQuantity());
            productRepository.save(product);
        }

        order.setTotalAmount(totalAmount);
        order.setOrderDetails(orderDetails);

        Order savedOrder = orderRepository.save(order);

        // Automatically create payment record with PENDING status
        try {
            PaymentRequest paymentRequest = new PaymentRequest();
            paymentRequest.setOrderId(savedOrder.getId());
            paymentRequest.setAmount(savedOrder.getTotalAmount());
            paymentRequest.setPaymentMethod(savedOrder.getPaymentMethod());
            paymentRequest.setStatus("pending");
            paymentService.createPayment(savedOrder.getId(), paymentRequest);
        } catch (Exception e) {
            // Log error but don't fail order creation
            System.err.println("Failed to create payment record: " + e.getMessage());
        }

        return convertToDTO(savedOrder);
    }

    @Transactional
    public OrderDTO updateOrderStatus(Integer id, String status) {
        Order.Status newStatus = Order.Status.valueOf(status.toUpperCase());

        // If new status is CANCELLED, delegate to cancelOrder to handle stock
        // restoration
        if (newStatus == Order.Status.CANCELLED) {
            cancelOrder(id);
            return getOrderById(id);
        }

        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Order not found with id: " + id));

        order.setStatus(newStatus);
        Order updatedOrder = orderRepository.save(order);

        // If order status is PAID or DELIVERED, update payment status to PAID
        if (newStatus == Order.Status.PAID || newStatus == Order.Status.DELIVERED) {
            try {
                List<PaymentDTO> paymentsForOrder = paymentService.getPaymentsByOrderId(id);
                for (PaymentDTO paymentDTO : paymentsForOrder) {
                    if ("pending".equalsIgnoreCase(paymentDTO.getStatus())) {
                        paymentService.updatePaymentStatus(paymentDTO.getId(), "paid");
                    }
                }
            } catch (Exception e) {
                // Log error but don't fail order status update
                System.err.println("Failed to update payment status: " + e.getMessage());
            }
        }

        return convertToDTO(updatedOrder);
    }

    @Transactional
    public void cancelOrder(Integer id) {
        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Order not found with id: " + id));

        if (order.getStatus() == Order.Status.SHIPPED ||
                order.getStatus() == Order.Status.DELIVERED ||
                order.getStatus() == Order.Status.CANCELLED) {
            throw new RuntimeException("Cannot cancel order with status: " + order.getStatus());
        }

        // Restore product quantities
        for (OrderDetail detail : order.getOrderDetails()) {
            Product product = detail.getProduct();
            product.setQuantity(product.getQuantity() + detail.getQuantity());
            productRepository.save(product);
        }

        order.setStatus(Order.Status.CANCELLED);
        orderRepository.save(order);
    }

    private String generateOrderCode() {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        return "ORD" + timestamp;
    }

    private OrderDTO convertToDTO(Order order) {
        OrderDTO dto = new OrderDTO();
        dto.setId(order.getId());
        dto.setOrderCode(order.getOrderCode());
        dto.setCustomerName(order.getCustomerName());
        dto.setEmail(order.getEmail());
        dto.setPhone(order.getPhone());
        dto.setAddress(order.getAddress());
        dto.setTotalAmount(order.getTotalAmount());
        dto.setPaymentMethod(order.getPaymentMethod());
        dto.setStatus(order.getStatus().name().toLowerCase());
        dto.setCreatedAt(order.getCreatedAt());

        // Convert order details
        List<OrderItemDTO> items = order.getOrderDetails().stream()
                .map(detail -> {
                    OrderItemDTO itemDTO = new OrderItemDTO();
                    itemDTO.setProductId(detail.getProduct().getId());
                    itemDTO.setProductName(detail.getProduct().getName());
                    itemDTO.setQuantity(detail.getQuantity());
                    itemDTO.setPrice(detail.getPrice());
                    itemDTO.setSubtotal(detail.getSubtotal());
                    return itemDTO;
                })
                .collect(Collectors.toList());
        dto.setItems(items);

        // Convert payments
        try {
            List<PaymentDTO> payments = paymentService.getPaymentsByOrderId(order.getId());
            dto.setPayments(payments);
        } catch (Exception e) {
            // If payment service fails, set empty list
            dto.setPayments(new ArrayList<>());
        }

        return dto;
    }
}
