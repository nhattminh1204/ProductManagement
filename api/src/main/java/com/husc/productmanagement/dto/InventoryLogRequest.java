package com.husc.productmanagement.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class InventoryLogRequest {
    @NotNull(message = "Product ID is required")
    private Integer productId;

    @NotNull(message = "Change quantity is required")
    private Integer changeQuantity;

    @NotBlank(message = "Log type is required")
    private String logType;

    private String notes;
}
