package com.example.e_shop.domain.repositories;

import com.example.e_shop.domain.entities.User;
import java.util.Optional;

public interface UserRepository {
    Optional<User> findById(Long id);

    Optional<User> findByEmail(String email);

    boolean existsByEmail(String email);

    User save(User user);

    void delete(User user);
}
