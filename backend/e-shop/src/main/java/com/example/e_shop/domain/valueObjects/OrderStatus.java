package com.example.e_shop.domain.valueObjects;

import lombok.Getter;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

@Getter
public final class OrderStatus {
    private final String value;

    public static final OrderStatus PENDING = new OrderStatus("pending");
    public static final OrderStatus PROCESSING = new OrderStatus("processing");
    public static final OrderStatus SHIPPED = new OrderStatus("shipped");
    public static final OrderStatus DELIVERED = new OrderStatus("delivered");
    public static final OrderStatus CANCELLED = new OrderStatus("cancelled");

    private static final List<OrderStatus>VALUES = Arrays.asList(PENDING, PROCESSING, SHIPPED, DELIVERED, CANCELLED);
    private static final Map<String, OrderStatus>VALUE_MAP = VALUES.stream().collect(Collectors.toMap(status -> status.value, Function.identity()));

    private OrderStatus(String value){
        if (value == null || value.trim().isEmpty()) throw new IllegalArgumentException("Status can not empty!");
        this.value = value.toLowerCase();
    }

    public static Optional<OrderStatus> fromValue(String value) {
        if (value == null) {
            return Optional.empty();
        }
        String normalizedValue = value.toLowerCase();
        return Optional.ofNullable(VALUE_MAP.get(normalizedValue));
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof OrderStatus status)) return false;
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
