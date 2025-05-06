package com.example.e_shop.domain.valueObjects;

import lombok.Getter;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

@Getter
public class UserStatus {
    private final String value;

    public static final UserStatus ACTIVE = new UserStatus("active");
    public static final UserStatus INACTIVE = new UserStatus("inactive");
    public static final UserStatus LOCKED = new UserStatus("locked");

    private static final List<UserStatus>VALUES = Arrays.asList(ACTIVE, INACTIVE, LOCKED);
    private static final Map<String, UserStatus>VALUE_MAP = VALUES.stream().collect(Collectors.toMap(status -> status.value, Function.identity()));

    private UserStatus(String value){
        if (value == null || value.trim().isEmpty()) throw new IllegalArgumentException("Status can not empty!");
        this.value = value.toLowerCase();
    }

    public static Optional<UserStatus> fromValue(String value) {
        if (value == null) {
            return Optional.empty();
        }
        String normalizedValue = value.toLowerCase();
        return Optional.ofNullable(VALUE_MAP.get(normalizedValue));
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof UserStatus status)) return false;
        return value.equals(status.value);
    }

    @Override
    public int hashCode() {
        return Objects.hash(value);
    }

    @Override
    public String toString() {
        return value;
    }
}
