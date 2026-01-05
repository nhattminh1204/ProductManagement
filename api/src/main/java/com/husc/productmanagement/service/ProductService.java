package com.husc.productmanagement.service;

import com.husc.productmanagement.dto.ProductDTO;
import com.husc.productmanagement.entity.Category;
import com.husc.productmanagement.entity.Product;
import com.husc.productmanagement.repository.CategoryRepository;
import com.husc.productmanagement.repository.ProductRatingRepository;
import com.husc.productmanagement.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ProductService {

    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;
    private final ProductRatingRepository ratingRepository;

    @Transactional(readOnly = true)
    public List<ProductDTO> getAllProducts() {
        return productRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<ProductDTO> getActiveProducts() {
        return productRepository.findByStatus(Product.Status.ACTIVE).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public ProductDTO getProductById(Integer id) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found with id: " + id));
        return convertToDTO(product);
    }

    @Transactional(readOnly = true)
    public List<ProductDTO> getProductsByCategory(Integer categoryId) {
        return productRepository.findByCategoryId(categoryId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<ProductDTO> searchProducts(String keyword) {
        return productRepository.searchByKeyword(keyword).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<ProductDTO> filterProducts(String keyword, Integer categoryId, java.math.BigDecimal minPrice,
            java.math.BigDecimal maxPrice, Double minRating, String sortBy) {

        List<Product> products = productRepository.findWithFilters(keyword, categoryId, minPrice, maxPrice);

        // Filter by status ACTIVE
        List<ProductDTO> dtos = products.stream()
                .filter(p -> p.getStatus() == Product.Status.ACTIVE)
                .map(this::convertToDTO)
                .collect(Collectors.toList());

        // Filter by rating if provided
        if (minRating != null) {
            dtos = dtos.stream()
                    .filter(p -> p.getAverageRating() != null && p.getAverageRating() >= minRating)
                    .collect(Collectors.toList());
        }

        // Sort
        if (sortBy != null) {
            switch (sortBy.toLowerCase()) {
                case "price_asc":
                    dtos.sort((p1, p2) -> p1.getPrice().compareTo(p2.getPrice()));
                    break;
                case "price_desc":
                    dtos.sort((p1, p2) -> p2.getPrice().compareTo(p1.getPrice()));
                    break;
                case "rating":
                    dtos.sort((p1, p2) -> {
                        Double r1 = p1.getAverageRating() != null ? p1.getAverageRating() : 0.0;
                        Double r2 = p2.getAverageRating() != null ? p2.getAverageRating() : 0.0;
                        return r2.compareTo(r1); // Descending
                    });
                    break;
                case "newest":
                    // Assuming ID is proxy for newness, or we could add createdAt to DTO
                    dtos.sort((p1, p2) -> p2.getId().compareTo(p1.getId()));
                    break;
                default:
                    break;
            }
        }

        return dtos;
    }

    @Transactional
    public ProductDTO createProduct(ProductDTO productDTO) {
        Category category = categoryRepository.findById(productDTO.getCategoryId())
                .orElseThrow(() -> new RuntimeException("Category not found with id: " + productDTO.getCategoryId()));

        Product product = new Product();
        product.setName(productDTO.getName());
        product.setDescription(productDTO.getDescription());
        product.setImage(productDTO.getImage());
        product.setPrice(productDTO.getPrice());
        product.setDiscountPrice(productDTO.getDiscountPrice());
        product.setQuantity(productDTO.getQuantity());
        product.setStatus(productDTO.getStatus() != null ? Product.Status.valueOf(productDTO.getStatus().toUpperCase())
                : Product.Status.ACTIVE);
        product.setCategory(category);

        Product savedProduct = productRepository.save(product);
        return convertToDTO(savedProduct);
    }

    @Transactional
    public ProductDTO updateProduct(Integer id, ProductDTO productDTO) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found with id: " + id));

        if (productDTO.getCategoryId() != null && !productDTO.getCategoryId().equals(product.getCategory().getId())) {
            Category category = categoryRepository.findById(productDTO.getCategoryId())
                    .orElseThrow(
                            () -> new RuntimeException("Category not found with id: " + productDTO.getCategoryId()));
            product.setCategory(category);
        }

        if (productDTO.getName() != null) {
            product.setName(productDTO.getName());
        }
        if (productDTO.getDescription() != null) {
            product.setDescription(productDTO.getDescription());
        }
        if (productDTO.getImage() != null) {
            product.setImage(productDTO.getImage());
        }
        if (productDTO.getPrice() != null) {
            product.setPrice(productDTO.getPrice());
        }
        if (productDTO.getDiscountPrice() != null) {
            product.setDiscountPrice(productDTO.getDiscountPrice());
        }
        if (productDTO.getQuantity() != null) {
            product.setQuantity(productDTO.getQuantity());
        }
        if (productDTO.getStatus() != null) {
            product.setStatus(Product.Status.valueOf(productDTO.getStatus().toUpperCase()));
        }

        Product updatedProduct = productRepository.save(product);
        return convertToDTO(updatedProduct);
    }

    @Transactional
    public void deleteProduct(Integer id) {
        if (!productRepository.existsById(id)) {
            throw new RuntimeException("Product not found with id: " + id);
        }
        productRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public List<ProductDTO> getFeaturedProducts() {
        // Featured products: high rating (>= 4.0) and active
        return productRepository.findByStatus(Product.Status.ACTIVE).stream()
                .filter(product -> {
                    Double avgRating = ratingRepository.getAverageRatingByProductId(product.getId());
                    return avgRating != null && avgRating >= 4.0;
                })
                .map(this::convertToDTO)
                .sorted((p1, p2) -> {
                    Double r1 = p1.getAverageRating() != null ? p1.getAverageRating() : 0.0;
                    Double r2 = p2.getAverageRating() != null ? p2.getAverageRating() : 0.0;
                    return r2.compareTo(r1);
                })
                .limit(10)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<ProductDTO> getLowStockProducts() {
        // Low stock: quantity <= 10
        int threshold = 10;
        return productRepository.findByStatus(Product.Status.ACTIVE).stream()
                .filter(product -> product.getQuantity() <= threshold)
                .map(this::convertToDTO)
                .sorted((p1, p2) -> p1.getQuantity().compareTo(p2.getQuantity()))
                .collect(Collectors.toList());
    }

    private ProductDTO convertToDTO(Product product) {
        ProductDTO dto = new ProductDTO();
        dto.setId(product.getId());
        dto.setName(product.getName());
        dto.setDescription(product.getDescription());
        dto.setImage(product.getImage());
        dto.setPrice(product.getPrice());
        dto.setDiscountPrice(product.getDiscountPrice());
        dto.setQuantity(product.getQuantity());
        dto.setStatus(product.getStatus().name().toLowerCase());
        dto.setCategoryId(product.getCategory().getId());
        dto.setCategoryName(product.getCategory().getName());

        // Get average rating and total ratings
        Double avgRating = ratingRepository.getAverageRatingByProductId(product.getId());
        Long totalRatings = ratingRepository.countRatingsByProductId(product.getId());
        dto.setAverageRating(avgRating);
        dto.setTotalRatings(totalRatings);

        return dto;
    }
}
