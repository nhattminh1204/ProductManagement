package com.husc.productmanagement.controller;

import com.husc.productmanagement.dto.ApiResponse;
import com.husc.productmanagement.dto.LoginRequest;
import com.husc.productmanagement.dto.LoginResponse;
import com.husc.productmanagement.dto.UserDTO;
import com.husc.productmanagement.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<LoginResponse>> login(@Valid @RequestBody LoginRequest loginRequest) {
        LoginResponse loginResponse = authService.login(loginRequest);
        return ResponseEntity.ok(ApiResponse.success("Login successful", loginResponse));
    }

    @PostMapping("/register")
    public ResponseEntity<ApiResponse<UserDTO>> register(@Valid @RequestBody UserDTO userDTO) {
        UserDTO registeredUser = authService.register(userDTO);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Registration successful", registeredUser));
    }
}
