package com.husc.productmanagement.entity.converter;

import com.husc.productmanagement.entity.User;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = true)
public class RoleConverter implements AttributeConverter<User.Role, String> {

    @Override
    public String convertToDatabaseColumn(User.Role role) {
        if (role == null) {
            return null;
        }
        return role.getValue(); // Lưu "user" hoặc "admin" vào DB
    }

    @Override
    public User.Role convertToEntityAttribute(String dbData) {
        if (dbData == null || dbData.isEmpty()) {
            return null;
        }
        return User.Role.fromValue(dbData); // Đọc từ DB và convert sang enum
    }
}
