package com.husc.productmanagement.entity.converter;

import com.husc.productmanagement.entity.Category;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = true)
public class CategoryStatusConverter implements AttributeConverter<Category.Status, String> {

    @Override
    public String convertToDatabaseColumn(Category.Status status) {
        if (status == null) {
            return null;
        }
        return status.getValue(); // Lưu "active" hoặc "inactive" vào DB
    }

    @Override
    public Category.Status convertToEntityAttribute(String dbData) {
        if (dbData == null || dbData.isEmpty()) {
            return null;
        }
        // Convert "active" → Status.ACTIVE
        for (Category.Status status : Category.Status.values()) {
            if (status.getValue().equalsIgnoreCase(dbData) || status.name().equalsIgnoreCase(dbData)) {
                return status;
            }
        }
        return Category.Status.ACTIVE; // Default fallback
    }
}
