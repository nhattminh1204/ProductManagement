package com.husc.productmanagement.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "categories")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 100)
    private String name;

    @Convert(converter = com.husc.productmanagement.entity.converter.CategoryStatusConverter.class)
    @Column(nullable = false)
    private Status status = Status.ACTIVE;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @OneToMany(mappedBy = "category", cascade = CascadeType.ALL)
    private List<Product> products;

    public enum Status {
        ACTIVE("active"),
        INACTIVE("inactive");

        private final String value;

        Status(String value) {
            this.value = value;
        }

        @com.fasterxml.jackson.annotation.JsonValue
        public String getValue() {
            return value;
        }

        @com.fasterxml.jackson.annotation.JsonCreator
        public static Status fromValue(String value) {
            if (value == null)
                return ACTIVE;
            for (Status status : Status.values()) {
                if (status.value.equalsIgnoreCase(value) || status.name().equalsIgnoreCase(value)) {
                    return status;
                }
            }
            return ACTIVE; // Default fallback
        }
    }
}
