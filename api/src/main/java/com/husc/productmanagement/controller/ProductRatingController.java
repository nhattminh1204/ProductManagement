package com.husc.productmanagement.controller;

import com.husc.productmanagement.dto.ApiResponse;
import com.husc.productmanagement.dto.ProductRatingDTO;
import com.husc.productmanagement.service.ProductRatingService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/ratings")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class ProductRatingController {

    private final ProductRatingService ratingService;

    @GetMapping("/product/{productId}")
    public ResponseEntity<ApiResponse<List<ProductRatingDTO>>> getRatingsByProductId(@PathVariable Integer productId) {
        List<ProductRatingDTO> ratings = ratingService.getRatingsByProductId(productId);
        return ResponseEntity.ok(ApiResponse.success(ratings));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<ApiResponse<List<ProductRatingDTO>>> getRatingsByUserId(@PathVariable Integer userId) {
        List<ProductRatingDTO> ratings = ratingService.getRatingsByUserId(userId);
        return ResponseEntity.ok(ApiResponse.success(ratings));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<ProductRatingDTO>> createRating(@Valid @RequestBody ProductRatingDTO ratingDTO) {
        ProductRatingDTO createdRating = ratingService.createRating(ratingDTO);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Rating created successfully", createdRating));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteRating(@PathVariable Integer id) {
        ratingService.deleteRating(id);
        return ResponseEntity.ok(ApiResponse.success("Rating deleted successfully", null));
    }
}
