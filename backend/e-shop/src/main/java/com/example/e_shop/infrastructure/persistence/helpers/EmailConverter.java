package com.example.e_shop.infrastructure.persistence.helpers;
import com.example.e_shop.domain.valueObjects.Email;

import jakarta.persistence.Converter;

@Converter(autoApply = false)
public class EmailConverter extends ValueObjectConverter<Email> {
    @Override
    protected Email fromValue(String value) {
        return new Email(value);
    }

    @Override
    protected String toValue(Email valueObject) {
        return valueObject.getValue();
    }
}
