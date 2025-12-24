package com.husc.productmanagement.repository;

import com.husc.productmanagement.entity.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Integer> {

    List<Payment> findByOrderId(Integer orderId);

    List<Payment> findByStatus(Payment.Status status);
}
