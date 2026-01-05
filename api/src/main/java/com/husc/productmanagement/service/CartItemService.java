package com.husc.productmanagement.service;

import com.husc.productmanagement.dto.CartItemDTO;
import com.husc.productmanagement.entity.CartItem;
import com.husc.productmanagement.entity.Product;
import com.husc.productmanagement.entity.User;
import com.husc.productmanagement.repository.CartItemRepository;
import com.husc.productmanagement.repository.ProductRepository;
import com.husc.productmanagement.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CartItemService {

    private final CartItemRepository cartItemRepository;
    private final UserRepository userRepository;
    private final ProductRepository productRepository;

    @Transactional(readOnly = true)
    public List<CartItemDTO> getUserCart(Integer userId) {
        return cartItemRepository.findByUserId(userId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public CartItemDTO addToCart(Integer userId, Integer productId, Integer quantity) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        if (quantity <= 0) {
            throw new RuntimeException("Quantity must be greater than 0");
        }

        // Check availability
        if (product.getQuantity() < quantity) {
            throw new RuntimeException("Not enough stock");
        }

        CartItem cartItem = cartItemRepository.findByUserIdAndProductId(userId, productId)
                .orElse(new CartItem());

        if (cartItem.getId() == null) {
            cartItem.setUser(user);
            cartItem.setProduct(product);
            cartItem.setQuantity(quantity);
        } else {
            cartItem.setQuantity(cartItem.getQuantity() + quantity);
        }

        CartItem savedCartItem = cartItemRepository.save(cartItem);
        return convertToDTO(savedCartItem);
    }

    @Transactional
    public CartItemDTO updateQuantity(Integer userId, Integer productId, Integer quantity) {
        if (quantity <= 0) {
            removeFromCart(userId, productId);
            return null;
        }

        CartItem cartItem = cartItemRepository.findByUserIdAndProductId(userId, productId)
                .orElseThrow(() -> new RuntimeException("Cart item not found"));

        // Check availability for increased quantity
        if (quantity > cartItem.getQuantity()) {
            if (cartItem.getProduct().getQuantity() < quantity) {
                throw new RuntimeException("Not enough stock");
            }
        }

        cartItem.setQuantity(quantity);
        CartItem savedCartItem = cartItemRepository.save(cartItem);
        return convertToDTO(savedCartItem);
    }

    @Transactional
    public void removeFromCart(Integer userId, Integer productId) {
        CartItem cartItem = cartItemRepository.findByUserIdAndProductId(userId, productId)
                .orElseThrow(() -> new RuntimeException("Cart item not found"));
        cartItemRepository.delete(cartItem);
    }

    @Transactional
    public void clearCart(Integer userId) {
        cartItemRepository.deleteByUserId(userId);
    }

    private CartItemDTO convertToDTO(CartItem cartItem) {
        CartItemDTO dto = new CartItemDTO();
        dto.setId(cartItem.getId());
        dto.setUserId(cartItem.getUser().getId());
        dto.setProductId(cartItem.getProduct().getId());
        dto.setProductName(cartItem.getProduct().getName());
        dto.setProductImage(cartItem.getProduct().getImage());
        dto.setProductPrice(cartItem.getProduct().getPrice());
        dto.setQuantity(cartItem.getQuantity());
        dto.setProductStock(cartItem.getProduct().getQuantity());
        return dto;
    }
}
