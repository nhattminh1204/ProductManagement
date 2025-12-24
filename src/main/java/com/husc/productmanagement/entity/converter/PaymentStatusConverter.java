package com.husc.productmanagement.entity.converter;

import com.husc.productmanagement.entity.Payment;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = true)
public class PaymentStatusConverter implements AttributeConverter<Payment.Status, String> {

    @Override
    public String convertToDatabaseColumn(Payment.Status status) {
        if (status == null) {
            return null;
        }
        return status.getValue();
    }

    @Override
    public Payment.Status convertToEntityAttribute(String dbData) {
        if (dbData == null || dbData.isEmpty()) {
            return null;
        }
        for (Payment.Status status : Payment.Status.values()) {
            if (status.getValue().equalsIgnoreCase(dbData) || status.name().equalsIgnoreCase(dbData)) {
                return status;
            }
        }
        return Payment.Status.PENDING;
    }
}
