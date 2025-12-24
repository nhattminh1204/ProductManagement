package com.husc.productmanagement.service;

import com.husc.productmanagement.dto.LoginRequest;
import com.husc.productmanagement.dto.LoginResponse;
import com.husc.productmanagement.dto.UserDTO;
import com.husc.productmanagement.entity.User;
import com.husc.productmanagement.repository.UserRepository;
import com.husc.productmanagement.util.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    @Transactional
    public LoginResponse login(LoginRequest loginRequest) {
        User user = userRepository.findByEmail(loginRequest.getEmail())
                .orElseThrow(() -> new RuntimeException("Invalid email or password"));

        if (!passwordEncoder.matches(loginRequest.getPassword(), user.getPassword())) {
            throw new RuntimeException("Invalid email or password");
        }

        if (user.getStatus() == User.Status.INACTIVE) {
            throw new RuntimeException("Account is inactive");
        }

        String token = jwtUtil.generateToken(
                user.getEmail(),
                user.getId(),
                user.getRole().name());

        return new LoginResponse(
                token,
                user.getId(),
                user.getEmail(),
                user.getName(),
                user.getRole().name().toLowerCase());
    }

    @Transactional
    public UserDTO register(UserDTO userDTO) {
        if (userRepository.existsByEmail(userDTO.getEmail())) {
            throw new RuntimeException("Email already exists: " + userDTO.getEmail());
        }

        User user = new User();
        user.setName(userDTO.getName());
        user.setEmail(userDTO.getEmail());
        user.setPhone(userDTO.getPhone());
        user.setPassword(passwordEncoder.encode(userDTO.getPassword()));
        user.setRole(User.Role.USER); // Default role
        user.setStatus(User.Status.ACTIVE);

        User savedUser = userRepository.save(user);

        UserDTO responseDTO = new UserDTO();
        responseDTO.setId(savedUser.getId());
        responseDTO.setName(savedUser.getName());
        responseDTO.setEmail(savedUser.getEmail());
        responseDTO.setPhone(savedUser.getPhone());
        responseDTO.setRole(savedUser.getRole().name().toLowerCase());
        responseDTO.setStatus(savedUser.getStatus().name().toLowerCase());

        return responseDTO;
    }
}
