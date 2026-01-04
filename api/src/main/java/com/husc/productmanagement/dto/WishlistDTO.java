package com.husc.productmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class WishlistDTO {
    private Integer id;
    private Integer userId;
    private Integer productId;
    private String productName;
    private String productImage;
    private BigDecimal productPrice;
    private LocalDateTime createdAt;
}
