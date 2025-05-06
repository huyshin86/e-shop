package com.example.e_shop.domain.valueObjects;

import lombok.Getter;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

@Getter
public final class ShippingStatus {
    private final String value;

    public static final ShippingStatus PENDING = new ShippingStatus("pending");
    public static final ShippingStatus SHIPPED = new ShippingStatus("shipped");
    public static final ShippingStatus DELIVERED = new ShippingStatus("delivered");
    public static final ShippingStatus FAILED = new ShippingStatus("failed");

    private static final List<ShippingStatus> VALUES = Arrays.asList(PENDING, SHIPPED, DELIVERED, FAILED);
    private static final Map<String, ShippingStatus> VALUE_MAP = VALUES.stream().collect(Collectors.toMap(status -> status.value, Function.identity()));

    private ShippingStatus(String value){
        if(value == null || value.trim().isEmpty()) throw new IllegalArgumentException("Status can not be empty!");

        this.value = value.toLowerCase();
    }

    public static Optional<ShippingStatus> fromValue(String value){
        if (value == null) {
            return Optional.empty();
        }
        String normalizedValue = value.toLowerCase();
        return Optional.ofNullable(VALUE_MAP.get(normalizedValue));
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ShippingStatus status)) return false;
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
