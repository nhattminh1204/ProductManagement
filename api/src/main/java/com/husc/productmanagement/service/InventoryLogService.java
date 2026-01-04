package com.husc.productmanagement.service;

import com.husc.productmanagement.dto.InventoryLogDTO;
import com.husc.productmanagement.entity.InventoryLog;
import com.husc.productmanagement.entity.Product;
import com.husc.productmanagement.repository.InventoryLogRepository;
import com.husc.productmanagement.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class InventoryLogService {

    private final InventoryLogRepository inventoryLogRepository;
    private final ProductRepository productRepository;

    @Transactional
    public InventoryLogDTO createLog(Integer productId, Integer changeQuantity, String logTypeStr, String notes) {
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        InventoryLog.LogType logType = InventoryLog.LogType.fromValue(logTypeStr);

        // Update product quantity based on log type
        if (logType == InventoryLog.LogType.IMPORT) {
            product.setQuantity(product.getQuantity() + changeQuantity);
        } else if (logType == InventoryLog.LogType.EXPORT) {
            if (product.getQuantity() < changeQuantity) {
                throw new RuntimeException("Not enough stock for export");
            }
            product.setQuantity(product.getQuantity() - changeQuantity);
        } else if (logType == InventoryLog.LogType.ADJUSTMENT) {
            // Adjustment can be positive or negative
            product.setQuantity(product.getQuantity() + changeQuantity);
            if (product.getQuantity() < 0) {
                throw new RuntimeException("Resulting quantity cannot be negative");
            }
        }

        productRepository.save(product);

        InventoryLog log = new InventoryLog();
        log.setProduct(product);
        log.setChangeQuantity(changeQuantity);
        log.setLogType(logType);
        log.setNotes(notes);

        InventoryLog savedLog = inventoryLogRepository.save(log);
        return convertToDTO(savedLog);
    }

    @Transactional(readOnly = true)
    public List<InventoryLogDTO> getProductLogs(Integer productId) {
        return inventoryLogRepository.findByProductIdOrderByCreatedAtDesc(productId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<InventoryLogDTO> getAllLogs() {
        return inventoryLogRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    private InventoryLogDTO convertToDTO(InventoryLog log) {
        InventoryLogDTO dto = new InventoryLogDTO();
        dto.setId(log.getId());
        dto.setProductId(log.getProduct().getId());
        dto.setProductName(log.getProduct().getName());
        dto.setChangeQuantity(log.getChangeQuantity());
        dto.setLogType(log.getLogType().getValue());
        dto.setNotes(log.getNotes());
        dto.setCreatedAt(log.getCreatedAt());
        return dto;
    }
}
