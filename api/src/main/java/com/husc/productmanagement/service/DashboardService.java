package com.husc.productmanagement.service;

import com.husc.productmanagement.dto.DashboardDTO;
import com.husc.productmanagement.dto.OrderDTO;
import com.husc.productmanagement.entity.Order;
import com.husc.productmanagement.entity.Product;
import com.husc.productmanagement.repository.OrderRepository;
import com.husc.productmanagement.repository.ProductRepository;
import com.husc.productmanagement.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;
import com.husc.productmanagement.dto.TopProductDTO;

@Service
@RequiredArgsConstructor
public class DashboardService {

    private final OrderRepository orderRepository;
    private final ProductRepository productRepository;
    private final UserRepository userRepository;
    private final OrderService orderService;

    @Transactional(readOnly = true)
    public DashboardDTO getDashboardStats() {
        DashboardDTO dashboard = new DashboardDTO();

        // Total orders
        dashboard.setTotalOrders(orderRepository.count());

        // Total revenue (sum of all paid orders)
        BigDecimal totalRevenue = orderRepository.findAll().stream()
                .filter(order -> order.getStatus() == Order.Status.PAID || order.getStatus() == Order.Status.SHIPPED)
                .map(Order::getTotalAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        dashboard.setTotalRevenue(totalRevenue);

        // Total products
        dashboard.setTotalProducts(productRepository.count());

        // Total users
        dashboard.setTotalUsers(userRepository.count());

        // Recent orders (last 10)
        List<OrderDTO> recentOrders = orderRepository.findAll().stream()
                .sorted((o1, o2) -> o2.getCreatedAt().compareTo(o1.getCreatedAt()))
                .limit(10)
                .map(order -> {
                    try {
                        return orderService.getOrderById(order.getId());
                    } catch (Exception e) {
                        return null;
                    }
                })
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
        dashboard.setRecentOrders(recentOrders);

        // Top products (by quantity sold)
        Map<Integer, Long> productSales = orderRepository.findAll().stream()
                .flatMap(order -> order.getOrderDetails().stream())
                .collect(Collectors.groupingBy(
                        detail -> detail.getProduct().getId(),
                        Collectors.summingLong(detail -> detail.getQuantity().longValue())
                ));

        List<TopProductDTO> topProducts = productSales.entrySet().stream()
                .sorted(Map.Entry.<Integer, Long>comparingByValue().reversed())
                .limit(10)
                .map(entry -> {
                    Product product = productRepository.findById(entry.getKey())
                            .orElse(null);
                    if (product == null) return null;

                    TopProductDTO topProduct = new TopProductDTO();
                    topProduct.setProductId(product.getId());
                    topProduct.setProductName(product.getName());
                    topProduct.setTotalSold(entry.getValue());

                    // Calculate revenue for this product
                    BigDecimal revenue = orderRepository.findAll().stream()
                            .flatMap(order -> order.getOrderDetails().stream()
                                    .filter(detail -> detail.getProduct().getId().equals(entry.getKey())))
                            .map(detail -> detail.getSubtotal())
                            .reduce(BigDecimal.ZERO, BigDecimal::add);
                    topProduct.setTotalRevenue(revenue);

                    return topProduct;
                })
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
        dashboard.setTopProducts(topProducts);

        // Order stats by status
        Map<String, Long> orderStatsByStatus = orderRepository.findAll().stream()
                .collect(Collectors.groupingBy(
                        order -> order.getStatus().getValue(),
                        Collectors.counting()
                ));
        dashboard.setOrderStatsByStatus(orderStatsByStatus);

        return dashboard;
    }

    @Transactional(readOnly = true)
    public Map<String, BigDecimal> getRevenueByPeriod(String period) {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime startDate;

        switch (period.toLowerCase()) {
            case "daily":
                startDate = now.minusDays(1);
                break;
            case "weekly":
                startDate = now.minusWeeks(1);
                break;
            case "monthly":
                startDate = now.minusMonths(1);
                break;
            case "yearly":
                startDate = now.minusYears(1);
                break;
            default:
                startDate = now.minusMonths(1);
        }

        return orderRepository.findAll().stream()
                .filter(order -> order.getCreatedAt().isAfter(startDate))
                .filter(order -> order.getStatus() == Order.Status.PAID || order.getStatus() == Order.Status.SHIPPED)
                .collect(Collectors.groupingBy(
                        order -> order.getCreatedAt().toLocalDate().toString(),
                        Collectors.reducing(
                                BigDecimal.ZERO,
                                Order::getTotalAmount,
                                BigDecimal::add
                        )
                ));
    }

    @Transactional(readOnly = true)
    public List<TopProductDTO> getTopProducts(Integer limit) {
        Map<Integer, Long> productSales = orderRepository.findAll().stream()
                .flatMap(order -> order.getOrderDetails().stream())
                .collect(Collectors.groupingBy(
                        detail -> detail.getProduct().getId(),
                        Collectors.summingLong(detail -> detail.getQuantity().longValue())
                ));

        return productSales.entrySet().stream()
                .sorted(Map.Entry.<Integer, Long>comparingByValue().reversed())
                .limit(limit != null ? limit : 10)
                .map(entry -> {
                    Product product = productRepository.findById(entry.getKey())
                            .orElse(null);
                    if (product == null) return null;

                    TopProductDTO topProduct = new TopProductDTO();
                    topProduct.setProductId(product.getId());
                    topProduct.setProductName(product.getName());
                    topProduct.setTotalSold(entry.getValue());

                    BigDecimal revenue = orderRepository.findAll().stream()
                            .flatMap(order -> order.getOrderDetails().stream()
                                    .filter(detail -> detail.getProduct().getId().equals(entry.getKey())))
                            .map(detail -> detail.getSubtotal())
                            .reduce(BigDecimal.ZERO, BigDecimal::add);
                    topProduct.setTotalRevenue(revenue);

                    return topProduct;
                })
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public Map<String, Long> getOrderStatsByStatus() {
        return orderRepository.findAll().stream()
                .collect(Collectors.groupingBy(
                        order -> order.getStatus().getValue(),
                        Collectors.counting()
                ));
    }
}

