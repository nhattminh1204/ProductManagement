package com.husc.productmanagement.entity.converter;

import com.husc.productmanagement.entity.Order;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = true)
public class OrderStatusConverter implements AttributeConverter<Order.Status, String> {

    @Override
    public String convertToDatabaseColumn(Order.Status status) {
        if (status == null) {
            return null;
        }
        return status.getValue();
    }

    @Override
    public Order.Status convertToEntityAttribute(String dbData) {
        if (dbData == null || dbData.isEmpty()) {
            return null;
        }
        for (Order.Status status : Order.Status.values()) {
            if (status.getValue().equalsIgnoreCase(dbData) || status.name().equalsIgnoreCase(dbData)) {
                return status;
            }
        }
        return Order.Status.PENDING;
    }
}
