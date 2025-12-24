package com.husc.productmanagement.entity.converter;

import com.husc.productmanagement.entity.Product;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = true)
public class ProductStatusConverter implements AttributeConverter<Product.Status, String> {

    @Override
    public String convertToDatabaseColumn(Product.Status status) {
        if (status == null) {
            return null;
        }
        return status.getValue(); // Lưu "active" hoặc "inactive" vào DB
    }

    @Override
    public Product.Status convertToEntityAttribute(String dbData) {
        if (dbData == null || dbData.isEmpty()) {
            return null;
        }
        // Convert "active" → Status.ACTIVE
        for (Product.Status status : Product.Status.values()) {
            if (status.getValue().equalsIgnoreCase(dbData) || status.name().equalsIgnoreCase(dbData)) {
                return status;
            }
        }
        return Product.Status.ACTIVE; // Default fallback
    }
}
