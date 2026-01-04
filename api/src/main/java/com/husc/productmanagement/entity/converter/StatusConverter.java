package com.husc.productmanagement.entity.converter;

import com.husc.productmanagement.entity.User;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = true)
public class StatusConverter implements AttributeConverter<User.Status, String> {

    @Override
    public String convertToDatabaseColumn(User.Status status) {
        if (status == null) {
            return null;
        }
        return status.getValue(); // Lưu "active" hoặc "inactive" vào DB
    }

    @Override
    public User.Status convertToEntityAttribute(String dbData) {
        if (dbData == null || dbData.isEmpty()) {
            return null;
        }
        return User.Status.fromValue(dbData); // Đọc từ DB và convert sang enum
    }
}
