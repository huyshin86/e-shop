package com.example.e_shop.domain.entities;

import com.example.e_shop.domain.valueObjects.Email;
import com.example.e_shop.domain.valueObjects.UserStatus;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class User {
    private final Long id;
    private Email email;
    private Role role;
    private UserStatus status;
}