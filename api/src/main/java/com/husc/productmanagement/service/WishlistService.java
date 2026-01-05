package com.husc.productmanagement.service;

import com.husc.productmanagement.dto.WishlistDTO;
import com.husc.productmanagement.dto.ProductDTO;
import com.husc.productmanagement.entity.Product;
import com.husc.productmanagement.entity.User;
import com.husc.productmanagement.entity.Wishlist;
import com.husc.productmanagement.entity.ProductRating;
import com.husc.productmanagement.repository.ProductRepository;
import com.husc.productmanagement.repository.UserRepository;
import com.husc.productmanagement.repository.WishlistRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class WishlistService {

    private final WishlistRepository wishlistRepository;
    private final UserRepository userRepository;
    private final ProductRepository productRepository;

    @Transactional(readOnly = true)
    public List<WishlistDTO> getUserWishlist(Integer userId) {
        return wishlistRepository.findByUserId(userId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public WishlistDTO addToWishlist(Integer userId, Integer productId) {
        if (wishlistRepository.existsByUserIdAndProductId(userId, productId)) {
            throw new RuntimeException("Product already in wishlist");
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        Wishlist wishlist = new Wishlist();
        wishlist.setUser(user);
        wishlist.setProduct(product);

        Wishlist savedWishlist = wishlistRepository.save(wishlist);
        return convertToDTO(savedWishlist);
    }

    @Transactional
    public void removeFromWishlist(Integer userId, Integer productId) {
        Wishlist wishlist = wishlistRepository.findByUserIdAndProductId(userId, productId)
                .orElseThrow(() -> new RuntimeException("Wishlist item not found"));
        wishlistRepository.delete(wishlist);
    }

    private WishlistDTO convertToDTO(Wishlist wishlist) {
        WishlistDTO dto = new WishlistDTO();
        dto.setId(wishlist.getId());
        dto.setUserId(wishlist.getUser().getId());
        dto.setProductId(wishlist.getProduct().getId());

        Product product = wishlist.getProduct();
        ProductDTO productDTO = new ProductDTO();
        productDTO.setId(product.getId());
        productDTO.setName(product.getName());
        productDTO.setDescription(product.getDescription());
        productDTO.setImage(product.getImage());
        productDTO.setPrice(product.getPrice());
        productDTO.setDiscountPrice(product.getDiscountPrice());
        productDTO.setQuantity(product.getQuantity());
        productDTO.setStatus(product.getStatus().getValue());
        if (product.getCategory() != null) {
            productDTO.setCategoryId(product.getCategory().getId());
            productDTO.setCategoryName(product.getCategory().getName());
        }

        if (product.getRatings() != null && !product.getRatings().isEmpty()) {
            double average = product.getRatings().stream()
                    .mapToInt(rating -> rating.getRating())
                    .average()
                    .orElse(0.0);
            productDTO.setAverageRating(average);
            productDTO.setTotalRatings((long) product.getRatings().size());
        } else {
            productDTO.setAverageRating(0.0);
            productDTO.setTotalRatings(0L);
        }

        dto.setProduct(productDTO);
        dto.setCreatedAt(wishlist.getCreatedAt());
        return dto;
    }
}
