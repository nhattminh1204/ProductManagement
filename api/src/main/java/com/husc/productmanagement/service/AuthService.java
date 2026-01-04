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
        String identifier = loginRequest.getUsernameOrEmail().trim().toLowerCase();

        User user = userRepository.findByUsernameOrEmail(identifier, identifier)
                .orElseThrow(() -> new RuntimeException("Invalid username/email or password"));

        if (!passwordEncoder.matches(loginRequest.getPassword(), user.getPassword())) {
            throw new RuntimeException("Invalid username/email or password");
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
                user.getUsername(),
                user.getName(),
                user.getRole().name().toLowerCase());
    }

    @Transactional
    public UserDTO register(UserDTO userDTO) {
        String email = userDTO.getEmail().trim().toLowerCase();
        String username = userDTO.getUsername().trim().toLowerCase();

        if (userRepository.existsByEmail(email)) {
            throw new RuntimeException("Email already exists: " + email);
        }
        if (userRepository.existsByUsername(username)) {
            throw new RuntimeException("Username already exists: " + username);
        }

        User user = new User();
        user.setName(userDTO.getName());
        user.setUsername(username);
        user.setEmail(email);
        user.setPhone(userDTO.getPhone());
        user.setAddress(userDTO.getAddress());
        user.setPassword(passwordEncoder.encode(userDTO.getPassword()));
        user.setRole(User.Role.USER); // Default role
        user.setStatus(User.Status.ACTIVE);

        User savedUser = userRepository.save(user);

        UserDTO responseDTO = new UserDTO();
        responseDTO.setId(savedUser.getId());
        responseDTO.setName(savedUser.getName());
        responseDTO.setUsername(savedUser.getUsername());
        responseDTO.setEmail(savedUser.getEmail());
        responseDTO.setPhone(savedUser.getPhone());
        responseDTO.setAddress(savedUser.getAddress());
        responseDTO.setRole(savedUser.getRole().name().toLowerCase());
        responseDTO.setStatus(savedUser.getStatus().name().toLowerCase());

        return responseDTO;
    }
}
