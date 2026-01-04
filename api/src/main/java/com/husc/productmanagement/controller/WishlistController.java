package com.husc.productmanagement.controller;

import com.husc.productmanagement.dto.ApiResponse;
import com.husc.productmanagement.dto.WishlistDTO;
import com.husc.productmanagement.service.WishlistService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/wishlists")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class WishlistController {

    private final WishlistService wishlistService;

    @GetMapping("/user/{userId}")
    public ResponseEntity<ApiResponse<List<WishlistDTO>>> getUserWishlist(@PathVariable Integer userId) {
        List<WishlistDTO> wishlist = wishlistService.getUserWishlist(userId);
        return ResponseEntity.ok(ApiResponse.success("Wishlist retrieved successfully", wishlist));
    }

    @PostMapping("/user/{userId}/add/{productId}")
    public ResponseEntity<ApiResponse<WishlistDTO>> addToWishlist(
            @PathVariable Integer userId,
            @PathVariable Integer productId) {
        WishlistDTO wishlistDTO = wishlistService.addToWishlist(userId, productId);
        return ResponseEntity.ok(ApiResponse.success("Product added to wishlist", wishlistDTO));
    }

    @DeleteMapping("/user/{userId}/remove/{productId}")
    public ResponseEntity<ApiResponse<Void>> removeFromWishlist(
            @PathVariable Integer userId,
            @PathVariable Integer productId) {
        wishlistService.removeFromWishlist(userId, productId);
        return ResponseEntity.ok(ApiResponse.success("Product removed from wishlist", null));
    }
}
