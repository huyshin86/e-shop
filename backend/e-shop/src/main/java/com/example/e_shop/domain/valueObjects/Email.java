package com.example.e_shop.domain.valueObjects;

import lombok.Getter;

import java.util.Objects;
import java.util.regex.Pattern;

@Getter
public final class Email {
    private static final String EMAIL_REGEX =
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
    private static final Pattern EMAIL_PATTERN = Pattern.compile(EMAIL_REGEX);

    private final String value;

    public Email(String value) {
        if (value == null || !EMAIL_PATTERN.matcher(value).matches()) throw new IllegalArgumentException("Invalid email address: " + value);
        this.value = value.toLowerCase(); // normalize
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Email email)) return false;
        return value.equals(email.value);
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