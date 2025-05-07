package com.example.e_shop.application.services.users;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.e_shop.application.dtos.users.UserRegistrationDto;
import com.example.e_shop.domain.entities.Role;
import com.example.e_shop.domain.entities.User;
import com.example.e_shop.domain.repositories.RoleRepository;
import com.example.e_shop.domain.repositories.UserRepository;
import com.example.e_shop.domain.valueObjects.Email;

// This service is for registering users' credentials, no user's information is needed
// This class is abstract and should be extended by specific user registration services (e.g., AdminRegisterUserService, RegisterCustomerService)
@Service
public abstract class RegisterUserService {
    protected final UserRepository userRepository;
    protected final RoleRepository roleRepository;
    protected final PasswordEncoder passwordEncoder;

    protected RegisterUserService(UserRepository userRepository, RoleRepository roleRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public final User registerUser(UserRegistrationDto dto) {
        validateDto(dto);
        validateCustomRules(dto);
        checkIfUserExists(dto.getEmail());
        return createAndSaveUser(dto, getRoleName());
    }

    protected void validateDto(UserRegistrationDto dto) {
        if (dto == null) {
            throw new IllegalArgumentException("User registration DTO cannot be null");
        }
        if (dto.getEmail() == null || dto.getEmail().isEmpty()) {
            throw new IllegalArgumentException("Email cannot be null or empty");
        }
        if (dto.getPassword() == null || dto.getPassword().isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }
    }

    // This method should be overridden by subclasses to implement custom validation rules
    private void validateCustomRules(UserRegistrationDto dto) {
    }

    protected void checkIfUserExists(String email) {
        if (userRepository.existsByEmail(email)) {
            throw new IllegalArgumentException("User with this email already exists");
        }
    }
    protected User createAndSaveUser(UserRegistrationDto dto, String roleName) {
        Role role = roleRepository.findByName(roleName).orElseGet(() -> {
            Role newRole = new Role(roleName);
            return roleRepository.save(newRole);
        });

        Email email = new Email(dto.getEmail());
        String hashedPassword = passwordEncoder.encode(dto.getPassword());

        User user = new User(email, hashedPassword, role);
        return userRepository.save(user);
    }

    // This method should be overridden by subclasses to provide the specific role name
    protected abstract String getRoleName();
}