package com.husc.productmanagement.controller;

import com.husc.productmanagement.dto.ApiResponse;
import com.husc.productmanagement.dto.InventoryLogDTO;
import com.husc.productmanagement.dto.InventoryLogRequest;
import com.husc.productmanagement.service.InventoryLogService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/inventory")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class InventoryLogController {

    private final InventoryLogService inventoryLogService;

    @PostMapping("/log")
    public ResponseEntity<ApiResponse<InventoryLogDTO>> createLog(@Valid @RequestBody InventoryLogRequest request) {
        InventoryLogDTO log = inventoryLogService.createLog(
                request.getProductId(),
                request.getChangeQuantity(),
                request.getLogType(),
                request.getNotes());
        return ResponseEntity.ok(ApiResponse.success("Inventory log created", log));
    }

    @GetMapping("/product/{productId}")
    public ResponseEntity<ApiResponse<List<InventoryLogDTO>>> getProductLogs(@PathVariable Integer productId) {
        List<InventoryLogDTO> logs = inventoryLogService.getProductLogs(productId);
        return ResponseEntity.ok(ApiResponse.success("Inventory logs retrieved", logs));
    }

    @GetMapping("/logs")
    public ResponseEntity<ApiResponse<List<InventoryLogDTO>>> getAllLogs() {
        List<InventoryLogDTO> logs = inventoryLogService.getAllLogs();
        return ResponseEntity.ok(ApiResponse.success("All inventory logs retrieved", logs));
    }
}
