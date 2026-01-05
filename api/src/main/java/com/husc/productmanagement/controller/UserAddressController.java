package com.husc.productmanagement.controller;

import com.husc.productmanagement.dto.ApiResponse;
import com.husc.productmanagement.dto.UserAddressDTO;
import com.husc.productmanagement.service.UserAddressService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/user-addresses")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class UserAddressController {

    private final UserAddressService userAddressService;

    @GetMapping("/user/{userId}")
    public ResponseEntity<ApiResponse<List<UserAddressDTO>>> getUserAddresses(@PathVariable Integer userId) {
        List<UserAddressDTO> addresses = userAddressService.getUserAddresses(userId);
        return ResponseEntity.ok(ApiResponse.success(addresses));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<UserAddressDTO>> getAddressById(@PathVariable Integer id) {
        UserAddressDTO address = userAddressService.getAddressById(id);
        return ResponseEntity.ok(ApiResponse.success(address));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<UserAddressDTO>> createAddress(@Valid @RequestBody UserAddressDTO dto) {
        UserAddressDTO created = userAddressService.createAddress(dto);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Address created successfully", created));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<UserAddressDTO>> updateAddress(
            @PathVariable Integer id,
            @Valid @RequestBody UserAddressDTO dto) {
        UserAddressDTO updated = userAddressService.updateAddress(id, dto);
        return ResponseEntity.ok(ApiResponse.success("Address updated successfully", updated));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteAddress(@PathVariable Integer id) {
        userAddressService.deleteAddress(id);
        return ResponseEntity.ok(ApiResponse.success("Address deleted successfully", null));
    }
}
