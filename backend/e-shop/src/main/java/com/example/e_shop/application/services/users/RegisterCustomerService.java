package com.example.e_shop.application.services.users;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.e_shop.domain.repositories.RoleRepository;
import com.example.e_shop.domain.repositories.UserRepository;

// This service is for registering customer's credentials, no customer's information is needed
@Service
public class RegisterCustomerService extends RegisterUserService {
    private static final String ROLE_NAME = "customer";

    public RegisterCustomerService(UserRepository userRepository, RoleRepository roleRepository, PasswordEncoder passwordEncoder) {
        super(userRepository, roleRepository, passwordEncoder);
    }

    @Override
    protected String getRoleName() {
        return ROLE_NAME;
    }
}
