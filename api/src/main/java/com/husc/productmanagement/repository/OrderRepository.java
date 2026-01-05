package com.husc.productmanagement.repository;

import com.husc.productmanagement.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface OrderRepository extends JpaRepository<Order, Integer> {

    Optional<Order> findByOrderCode(String orderCode);

    List<Order> findByStatus(Order.Status status);

    List<Order> findByEmail(String email);

    List<Order> findByCustomerNameContaining(String customerName);

    List<Order> findByUserId(Integer userId);
}
