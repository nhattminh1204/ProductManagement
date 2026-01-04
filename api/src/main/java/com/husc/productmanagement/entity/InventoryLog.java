package com.husc.productmanagement.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "inventory_logs")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class InventoryLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    @Column(name = "change_quantity", nullable = false)
    private Integer changeQuantity;

    @Convert(converter = LogTypeConverter.class)
    @Column(name = "log_type", nullable = false)
    private LogType logType;

    @Column(columnDefinition = "TEXT")
    private String notes;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    public enum LogType {
        IMPORT("import"),
        EXPORT("export"),
        ADJUSTMENT("adjustment");

        private final String value;

        LogType(String value) {
            this.value = value;
        }

        @com.fasterxml.jackson.annotation.JsonValue
        public String getValue() {
            return value;
        }

        @com.fasterxml.jackson.annotation.JsonCreator
        public static LogType fromValue(String value) {
            if (value == null)
                return null;
            for (LogType type : LogType.values()) {
                if (type.value.equalsIgnoreCase(value) || type.name().equalsIgnoreCase(value)) {
                    return type;
                }
            }
            throw new IllegalArgumentException("Unknown log type: " + value);
        }
    }

    @Converter(autoApply = true)
    public static class LogTypeConverter implements AttributeConverter<LogType, String> {
        @Override
        public String convertToDatabaseColumn(LogType attribute) {
            return (attribute == null) ? null : attribute.getValue();
        }

        @Override
        public LogType convertToEntityAttribute(String dbData) {
            return LogType.fromValue(dbData);
        }
    }
}
