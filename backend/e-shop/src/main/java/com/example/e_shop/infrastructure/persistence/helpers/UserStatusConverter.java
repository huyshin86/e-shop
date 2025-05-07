package com.example.e_shop.infrastructure.persistence.helpers;

import com.example.e_shop.domain.valueObjects.UserStatus;

public class UserStatusConverter extends ValueObjectConverter<UserStatus> {
    @Override
    protected UserStatus fromValue(String value) {
        return UserStatus.fromValue(value).orElseThrow(() -> new IllegalArgumentException("Invalid user status: " + value));
    }

    @Override
    protected String toValue(UserStatus valueObject) {
        return valueObject.getValue();

    }
}