package com.husc.productmanagement.service;

import com.husc.productmanagement.dto.UserAddressDTO;
import com.husc.productmanagement.entity.User;
import com.husc.productmanagement.entity.UserAddress;
import com.husc.productmanagement.exception.ResourceNotFoundException;
import com.husc.productmanagement.repository.UserAddressRepository;
import com.husc.productmanagement.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserAddressService {

    private final UserAddressRepository userAddressRepository;
    private final UserRepository userRepository;

    public List<UserAddressDTO> getUserAddresses(Integer userId) {
        return userAddressRepository.findByUserId(userId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public UserAddressDTO getAddressById(Integer id) {
        UserAddress address = userAddressRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Address not found"));
        return convertToDTO(address);
    }

    @Transactional
    public UserAddressDTO createAddress(UserAddressDTO dto) {
        User user = userRepository.findById(dto.getUserId())
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        // If this is the first address, make it default
        List<UserAddress> existing = userAddressRepository.findByUserId(dto.getUserId());
        if (existing.isEmpty()) {
            dto.setIsDefault(true);
        } else if (Boolean.TRUE.equals(dto.getIsDefault())) {
            // Unset other defaults
            unsetDefaultAddress(dto.getUserId());
        }

        UserAddress address = new UserAddress();
        address.setUser(user);
        updateEntityFromDTO(address, dto);

        UserAddress saved = userAddressRepository.save(address);
        return convertToDTO(saved);
    }

    @Transactional
    public UserAddressDTO updateAddress(Integer id, UserAddressDTO dto) {
        UserAddress address = userAddressRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Address not found"));

        if (Boolean.TRUE.equals(dto.getIsDefault()) && !Boolean.TRUE.equals(address.getIsDefault())) {
            unsetDefaultAddress(address.getUser().getId());
        }

        updateEntityFromDTO(address, dto);
        UserAddress saved = userAddressRepository.save(address);
        return convertToDTO(saved);
    }

    @Transactional
    public void deleteAddress(Integer id) {
        UserAddress address = userAddressRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Address not found"));
        userAddressRepository.delete(address);
    }

    private void unsetDefaultAddress(Integer userId) {
        List<UserAddress> defaults = userAddressRepository.findByUserIdAndIsDefaultTrue(userId);
        for (UserAddress addr : defaults) {
            addr.setIsDefault(false);
            userAddressRepository.save(addr);
        }
    }

    private UserAddressDTO convertToDTO(UserAddress entity) {
        return new UserAddressDTO(
                entity.getId(),
                entity.getUser().getId(),
                entity.getRecipientName(),
                entity.getPhone(),
                entity.getAddress(),
                entity.getCity(),
                entity.getIsDefault(),
                entity.getCreatedAt(),
                entity.getUpdatedAt());
    }

    private void updateEntityFromDTO(UserAddress entity, UserAddressDTO dto) {
        entity.setRecipientName(dto.getRecipientName());
        entity.setPhone(dto.getPhone());
        entity.setAddress(dto.getAddress());
        entity.setCity(dto.getCity());
        if (dto.getIsDefault() != null) {
            entity.setIsDefault(dto.getIsDefault());
        }
    }
}
