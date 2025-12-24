package com.husc.productmanagement.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderDTO {

    private Integer id;

    private String orderCode;

    @NotBlank(message = "Customer name is required")
    private String customerName;

    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    private String email;

    @NotBlank(message = "Phone is required")
    private String phone;

    @NotBlank(message = "Address is required")
    private String address;

    private BigDecimal totalAmount;

    @NotBlank(message = "Payment method is required")
    private String paymentMethod;

    private String status;

    @NotNull(message = "Order items are required")
    @Size(min = 1, message = "At least one item is required")
    @Valid
    private List<OrderItemDTO> items;
}
