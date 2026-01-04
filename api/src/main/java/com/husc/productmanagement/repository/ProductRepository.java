package com.husc.productmanagement.repository;

import com.husc.productmanagement.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Integer> {

    List<Product> findByStatus(Product.Status status);

    List<Product> findByCategoryId(Integer categoryId);

    List<Product> findByCategoryIdAndStatus(Integer categoryId, Product.Status status);

    @Query("SELECT p FROM Product p WHERE p.name LIKE %:keyword% OR p.category.name LIKE %:keyword%")
    List<Product> searchByKeyword(@Param("keyword") String keyword);

    @Query("SELECT p FROM Product p WHERE p.price BETWEEN :minPrice AND :maxPrice")
    List<Product> findByPriceRange(@Param("minPrice") Double minPrice, @Param("maxPrice") Double maxPrice);
}
