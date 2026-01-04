package com.husc.productmanagement.repository;

import com.husc.productmanagement.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Integer> {

    List<Category> findByStatus(Category.Status status);

    boolean existsByName(String name);
}
