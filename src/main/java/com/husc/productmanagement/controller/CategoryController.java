package com.husc.productmanagement.controller;

import com.husc.productmanagement.dto.ApiResponse;
import com.husc.productmanagement.dto.CategoryDTO;
import com.husc.productmanagement.service.CategoryService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/categories")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class CategoryController {

    private final CategoryService categoryService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<CategoryDTO>>> getAllCategories() {
        List<CategoryDTO> categories = categoryService.getAllCategories();
        return ResponseEntity.ok(ApiResponse.success(categories));
    }

    @GetMapping("/active")
    public ResponseEntity<ApiResponse<List<CategoryDTO>>> getActiveCategories() {
        List<CategoryDTO> categories = categoryService.getActiveCategories();
        return ResponseEntity.ok(ApiResponse.success(categories));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<CategoryDTO>> getCategoryById(@PathVariable Integer id) {
        CategoryDTO category = categoryService.getCategoryById(id);
        return ResponseEntity.ok(ApiResponse.success(category));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<CategoryDTO>> createCategory(@Valid @RequestBody CategoryDTO categoryDTO) {
        CategoryDTO createdCategory = categoryService.createCategory(categoryDTO);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Category created successfully", createdCategory));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<CategoryDTO>> updateCategory(
            @PathVariable Integer id,
            @Valid @RequestBody CategoryDTO categoryDTO) {
        CategoryDTO updatedCategory = categoryService.updateCategory(id, categoryDTO);
        return ResponseEntity.ok(ApiResponse.success("Category updated successfully", updatedCategory));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteCategory(@PathVariable Integer id) {
        categoryService.deleteCategory(id);
        return ResponseEntity.ok(ApiResponse.success("Category deleted successfully", null));
    }
}
