package com.example.e_shop.domain.repositories;

import java.util.Optional;

import com.example.e_shop.domain.entities.Role;

public interface RoleRepository {
    Optional<Role> findByName(String name);
    Role save(Role role);
}