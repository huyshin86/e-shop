package com.example.e_shop.infrastructure.persistence.helpers;

import jakarta.persistence.AttributeConverter;

public abstract class ValueObjectConverter<T> implements AttributeConverter<T, String> {
    protected abstract T fromValue(String value);
    protected abstract String toValue(T valueObject);

    @Override
    public String convertToDatabaseColumn(T attribute) {
        return attribute != null ? toValue(attribute) : null;
    }

    @Override
    public T convertToEntityAttribute(String dbData) {
        if (dbData == null) return null;
        return fromValue(dbData);
    }
}
