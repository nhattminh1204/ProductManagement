package com.husc.productmanagement.controller;

import com.husc.productmanagement.dto.ApiResponse;
import com.husc.productmanagement.dto.CartItemDTO;
import com.husc.productmanagement.service.CartItemService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/cart")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class CartItemController {

    private final CartItemService cartItemService;

    @GetMapping("/user/{userId}")
    public ResponseEntity<ApiResponse<List<CartItemDTO>>> getUserCart(@PathVariable Integer userId) {
        List<CartItemDTO> cart = cartItemService.getUserCart(userId);
        return ResponseEntity.ok(ApiResponse.success("Cart retrieved successfully", cart));
    }

    @PostMapping("/user/{userId}/add/{productId}")
    public ResponseEntity<ApiResponse<CartItemDTO>> addToCart(
            @PathVariable Integer userId,
            @PathVariable Integer productId,
            @RequestParam(defaultValue = "1") Integer quantity) {
        CartItemDTO cartItem = cartItemService.addToCart(userId, productId, quantity);
        return ResponseEntity.ok(ApiResponse.success("Product added to cart", cartItem));
    }

    @PutMapping("/user/{userId}/update/{productId}")
    public ResponseEntity<ApiResponse<CartItemDTO>> updateQuantity(
            @PathVariable Integer userId,
            @PathVariable Integer productId,
            @RequestParam Integer quantity) {
        CartItemDTO cartItem = cartItemService.updateQuantity(userId, productId, quantity);
        return ResponseEntity.ok(ApiResponse.success("Cart item updated", cartItem));
    }

    @DeleteMapping("/user/{userId}/remove/{productId}")
    public ResponseEntity<ApiResponse<Void>> removeFromCart(
            @PathVariable Integer userId,
            @PathVariable Integer productId) {
        cartItemService.removeFromCart(userId, productId);
        return ResponseEntity.ok(ApiResponse.success("Product removed from cart", null));
    }

    @DeleteMapping("/user/{userId}/clear")
    public ResponseEntity<ApiResponse<Void>> clearCart(@PathVariable Integer userId) {
        cartItemService.clearCart(userId);
        return ResponseEntity.ok(ApiResponse.success("Cart cleared", null));
    }
}
