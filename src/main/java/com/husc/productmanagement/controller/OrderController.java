package com.husc.productmanagement.controller;

import com.husc.productmanagement.dto.ApiResponse;
import com.husc.productmanagement.dto.OrderDTO;
import com.husc.productmanagement.service.OrderService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/orders")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class OrderController {

    private final OrderService orderService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<OrderDTO>>> getAllOrders() {
        List<OrderDTO> orders = orderService.getAllOrders();
        return ResponseEntity.ok(ApiResponse.success(orders));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<OrderDTO>> getOrderById(@PathVariable Integer id) {
        OrderDTO order = orderService.getOrderById(id);
        return ResponseEntity.ok(ApiResponse.success(order));
    }

    @GetMapping("/code/{orderCode}")
    public ResponseEntity<ApiResponse<OrderDTO>> getOrderByCode(@PathVariable String orderCode) {
        OrderDTO order = orderService.getOrderByCode(orderCode);
        return ResponseEntity.ok(ApiResponse.success(order));
    }

    @GetMapping("/customer/{email}")
    public ResponseEntity<ApiResponse<List<OrderDTO>>> getOrdersByEmail(@PathVariable String email) {
        List<OrderDTO> orders = orderService.getOrdersByEmail(email);
        return ResponseEntity.ok(ApiResponse.success(orders));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<OrderDTO>> createOrder(@Valid @RequestBody OrderDTO orderDTO) {
        OrderDTO createdOrder = orderService.createOrder(orderDTO);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Order created successfully", createdOrder));
    }

    @PatchMapping("/{id}/status")
    public ResponseEntity<ApiResponse<OrderDTO>> updateOrderStatus(
            @PathVariable Integer id,
            @RequestParam String status) {
        OrderDTO updatedOrder = orderService.updateOrderStatus(id, status);
        return ResponseEntity.ok(ApiResponse.success("Order status updated successfully", updatedOrder));
    }

    @DeleteMapping("/{id}/cancel")
    public ResponseEntity<ApiResponse<Void>> cancelOrder(@PathVariable Integer id) {
        orderService.cancelOrder(id);
        return ResponseEntity.ok(ApiResponse.success("Order cancelled successfully", null));
    }
}
