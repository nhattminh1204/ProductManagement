package com.husc.productmanagement.controller;

import com.husc.productmanagement.dto.ApiResponse;
import com.husc.productmanagement.dto.DashboardDTO;
import com.husc.productmanagement.dto.TopProductDTO;
import com.husc.productmanagement.service.DashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/dashboard")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class DashboardController {

    private final DashboardService dashboardService;

    @GetMapping("/stats")
    public ResponseEntity<ApiResponse<DashboardDTO>> getDashboardStats() {
        DashboardDTO stats = dashboardService.getDashboardStats();
        return ResponseEntity.ok(ApiResponse.success(stats));
    }

    @GetMapping("/revenue")
    public ResponseEntity<ApiResponse<Map<String, BigDecimal>>> getRevenueByPeriod(
            @RequestParam(defaultValue = "monthly") String period) {
        Map<String, BigDecimal> revenue = dashboardService.getRevenueByPeriod(period);
        return ResponseEntity.ok(ApiResponse.success(revenue));
    }

    @GetMapping("/top-products")
    public ResponseEntity<ApiResponse<List<TopProductDTO>>> getTopProducts(
            @RequestParam(required = false) Integer limit) {
        List<TopProductDTO> topProducts = dashboardService.getTopProducts(limit);
        return ResponseEntity.ok(ApiResponse.success(topProducts));
    }

    @GetMapping("/order-stats")
    public ResponseEntity<ApiResponse<Map<String, Long>>> getOrderStatsByStatus() {
        Map<String, Long> stats = dashboardService.getOrderStatsByStatus();
        return ResponseEntity.ok(ApiResponse.success(stats));
    }
}
