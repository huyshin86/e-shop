package com.example.e_shop.application.services.users;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.e_shop.domain.repositories.RoleRepository;
import com.example.e_shop.domain.repositories.UserRepository;

// This service is for registering store's credentials, no store's information is needed
@Service
@PreAuthorize("hasRole('admin') or hasRole('root_admin')")
public class RegisterStoreService extends RegisterUserService {
    private static final String ROLE_NAME = "store_manager";

    public RegisterStoreService(UserRepository userRepository, RoleRepository roleRepository, PasswordEncoder passwordEncoder) {
        super(userRepository, roleRepository, passwordEncoder);
    }

    @Override
    protected String getRoleName() {
        return ROLE_NAME;
    }
}
