package com.husc.productmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class InventoryLogDTO {
    private Integer id;
    private Integer productId;
    private String productName;
    private Integer changeQuantity;
    private String logType;
    private String notes;
    private LocalDateTime createdAt;
}
