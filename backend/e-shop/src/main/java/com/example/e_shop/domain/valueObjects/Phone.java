package com.example.e_shop.domain.valueObjects;

import lombok.Getter;

import java.util.Objects;
import java.util.regex.Pattern;

@Getter
public final class Phone {
    private static final String PHONE_REGEX =
            "^0[35789][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9]$";
    private static final Pattern PHONE_PATTERN = Pattern.compile(PHONE_REGEX);

    private final String number;

    public Phone(String number){
        if(number == null || !PHONE_PATTERN.matcher(number).matches()) throw new IllegalArgumentException("Invalid phone: " + number);
        this.number = number;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Phone phone)) return false;
        return number.equals(phone.number);
    }

    @Override
    public int hashCode() {
        return Objects.hash(number);
    }

    @Override
    public String toString() {
        return number;
    }
}