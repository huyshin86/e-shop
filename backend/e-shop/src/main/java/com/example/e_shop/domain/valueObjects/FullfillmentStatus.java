package com.example.e_shop.domain.valueObjects;

import lombok.Getter;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

@Getter
public final class FullfillmentStatus {
    private final String value;

    public static final FullfillmentStatus PENDING = new FullfillmentStatus("pending");
    public static final FullfillmentStatus SHIPPED = new FullfillmentStatus("shipped");
    public static final FullfillmentStatus DELIVERED = new FullfillmentStatus("delivered");
    public static final FullfillmentStatus RETURNED = new FullfillmentStatus("returned");

    private static final List<FullfillmentStatus> VALUES = Arrays.asList(PENDING, SHIPPED, DELIVERED, RETURNED);
    private static final Map<String, FullfillmentStatus> VALUE_MAP = VALUES.stream().collect(Collectors.toMap(status -> status.value, Function.identity()));

    private FullfillmentStatus(String value){
        if(value == null || value.trim().isEmpty()) throw new IllegalArgumentException("Status can not be empty!");

        this.value = value.toLowerCase();
    }

    public static Optional<FullfillmentStatus> fromValue(String value){
        if (value == null) {
            return Optional.empty();
        }
        String normalizedValue = value.toLowerCase();
        return Optional.ofNullable(VALUE_MAP.get(normalizedValue));
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof FullfillmentStatus status)) return false;
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
