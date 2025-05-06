package com.example.e_shop.domain.valueObjects;

import lombok.Getter;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

@Getter
public class AttributeType {
    private final String value;

    public static final AttributeType TEXT = new AttributeType("text");
    public static final AttributeType NUMBER = new AttributeType("number");
    public static final AttributeType BOOLEAN = new AttributeType("boolean");
    public static final AttributeType DATE = new AttributeType("date");

    private static final List<AttributeType> VALUES = Arrays.asList(TEXT, NUMBER, BOOLEAN, DATE);
    private static final Map<String, AttributeType> VALUE_MAP = VALUES.stream().collect(Collectors.toMap(status -> status.value, Function.identity()));

    private AttributeType(String value){
        if(value == null || value.trim().isEmpty()) throw new IllegalArgumentException("Attribute type can not be empty!");

        this.value = value.toLowerCase();
    }

    public static Optional<AttributeType> fromValue(String value){
        if (value == null) {
            return Optional.empty();
        }
        String normalizedValue = value.toLowerCase();
        return Optional.ofNullable(VALUE_MAP.get(normalizedValue));
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof AttributeType status)) return false;
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
