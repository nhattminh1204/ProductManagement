package com.husc.productmanagement.repository;

import com.husc.productmanagement.entity.ProductRating;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductRatingRepository extends JpaRepository<ProductRating, Integer> {

    List<ProductRating> findByProductId(Integer productId);

    List<ProductRating> findByUserId(Integer userId);

    @Query("SELECT AVG(pr.rating) FROM ProductRating pr WHERE pr.product.id = :productId")
    Double getAverageRatingByProductId(@Param("productId") Integer productId);

    @Query("SELECT COUNT(pr) FROM ProductRating pr WHERE pr.product.id = :productId")
    Long countRatingsByProductId(@Param("productId") Integer productId);
}
