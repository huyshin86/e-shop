package com.example.e_shop.domain.valueObjects;

import lombok.Getter;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

@Getter
public final class TransactionStatus {
    private final String value;

    public static final TransactionStatus PENDING = new TransactionStatus("pending");
    public static final TransactionStatus COMPLETED = new TransactionStatus("completed");
    public static final TransactionStatus FAILED = new TransactionStatus("failed");

    private static final List<TransactionStatus>VALUES = Arrays.asList(PENDING, COMPLETED, FAILED);
    private static final Map<String, TransactionStatus>VALUE_MAP = VALUES.stream().collect(Collectors.toMap(status -> status.value, Function.identity()));

    private TransactionStatus(String value){
        if(value == null || value.trim().isEmpty()) throw new IllegalArgumentException("Status can not be empty!");
        this.value = value.toLowerCase();
    }

    public static Optional<TransactionStatus> fromValue(String value){
        if (value == null) {
            return Optional.empty();
        }
        String normalizedValue = value.toLowerCase();
        return Optional.ofNullable(VALUE_MAP.get(normalizedValue));
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof TransactionStatus status)) return false;
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
