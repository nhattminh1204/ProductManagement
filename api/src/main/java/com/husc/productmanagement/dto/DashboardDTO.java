package com.husc.productmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DashboardDTO {

    private Long totalOrders;
    private BigDecimal totalRevenue;
    private Long totalProducts;
    private Long totalUsers;
    private List<OrderDTO> recentOrders;
    private List<TopProductDTO> topProducts;
    private Map<String, Long> orderStatsByStatus;
}
