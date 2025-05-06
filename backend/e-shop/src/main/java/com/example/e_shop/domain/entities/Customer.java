package com.example.e_shop.domain.entities;

import com.example.e_shop.domain.valueObjects.Phone;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.time.LocalDate;

@Getter
@AllArgsConstructor
public class Customer {
    private final Long id;
    private final User user;
    private String firstName;
    private String lastName;
    private LocalDate birthDate;
    private Phone phoneNumber;
}