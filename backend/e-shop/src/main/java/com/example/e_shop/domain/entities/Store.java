package com.example.e_shop.domain.entities;

import com.example.e_shop.domain.valueObjects.Address;
import com.example.e_shop.domain.valueObjects.Phone;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class Store {
    private final Long id;
    private final User user;
    private String name;
    private Address address;
    private Phone phone;
}