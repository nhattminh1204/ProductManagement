package com.husc.productmanagement.repository;

import com.husc.productmanagement.entity.InventoryLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface InventoryLogRepository extends JpaRepository<InventoryLog, Integer> {

    List<InventoryLog> findByProductIdOrderByCreatedAtDesc(Integer productId);
}
