package com.husc.productmanagement.service;

import com.husc.productmanagement.dto.ProductRatingDTO;
import com.husc.productmanagement.entity.Product;
import com.husc.productmanagement.entity.ProductRating;
import com.husc.productmanagement.entity.User;
import com.husc.productmanagement.repository.ProductRatingRepository;
import com.husc.productmanagement.repository.ProductRepository;
import com.husc.productmanagement.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ProductRatingService {

    private final ProductRatingRepository ratingRepository;
    private final ProductRepository productRepository;
    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public List<ProductRatingDTO> getRatingsByProductId(Integer productId) {
        return ratingRepository.findByProductId(productId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<ProductRatingDTO> getRatingsByUserId(Integer userId) {
        return ratingRepository.findByUserId(userId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public ProductRatingDTO createRating(ProductRatingDTO ratingDTO) {
        Product product = productRepository.findById(ratingDTO.getProductId())
                .orElseThrow(() -> new RuntimeException("Product not found with id: " + ratingDTO.getProductId()));

        User user = userRepository.findById(ratingDTO.getUserId())
                .orElseThrow(() -> new RuntimeException("User not found with id: " + ratingDTO.getUserId()));

        ProductRating rating = new ProductRating();
        rating.setProduct(product);
        rating.setUser(user);
        rating.setRating(ratingDTO.getRating());
        rating.setComment(ratingDTO.getComment());

        ProductRating savedRating = ratingRepository.save(rating);
        return convertToDTO(savedRating);
    }

    @Transactional
    public void deleteRating(Integer id) {
        if (!ratingRepository.existsById(id)) {
            throw new RuntimeException("Rating not found with id: " + id);
        }
        ratingRepository.deleteById(id);
    }

    private ProductRatingDTO convertToDTO(ProductRating rating) {
        ProductRatingDTO dto = new ProductRatingDTO();
        dto.setId(rating.getId());
        dto.setProductId(rating.getProduct().getId());
        dto.setProductName(rating.getProduct().getName());
        dto.setUserId(rating.getUser().getId());
        dto.setUserName(rating.getUser().getName());
        dto.setRating(rating.getRating());
        dto.setComment(rating.getComment());
        return dto;
    }
}
