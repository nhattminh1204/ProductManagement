package com.husc.productmanagement.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProductDTO {

    private Integer id;

    @NotBlank(message = "Product name is required")
    private String name;

    private String image;

    @NotNull(message = "Price is required")
    @DecimalMin(value = "0.0", inclusive = false, message = "Price must be greater than 0")
    private BigDecimal price;

    @NotNull(message = "Quantity is required")
    @Min(value = 0, message = "Quantity must be at least 0")
    private Integer quantity;

    private String status;

    @NotNull(message = "Category ID is required")
    private Integer categoryId;

    private String categoryName;

    private Double averageRating;

    private Long totalRatings;
}
