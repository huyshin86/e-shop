package com.example.e_shop.domain.valueObjects;

import lombok.Getter;

import java.util.Objects;

@Getter
public class Address {
    private final String houseNumber;
    private final String ward;
    private final String district;
    private final String city;

    public Address(String houseNumber, String ward, String district, String city){
        if (houseNumber == null || houseNumber.isEmpty()) {
            throw new IllegalArgumentException("House number cannot be empty");
        }
        if (district == null || district.isEmpty()) {
            throw new IllegalArgumentException("District cannot be empty");
        }
        if (ward == null || ward.isEmpty()) {
            throw new IllegalArgumentException("District cannot be empty");
        }
        if (city == null || city.isEmpty()) {
            throw new IllegalArgumentException("City cannot be empty");
        }

        this.houseNumber = houseNumber;
        this.ward = ward;
        this.district = district;
        this.city = city;
    }

    public String format() {
        return houseNumber + ", " + ward + ", " + district + ", " + city + ", Việt Nam";
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Address address = (Address) o;
        return houseNumber.equals(address.houseNumber) &&
                ward.equals(address.ward) &&
                district.equals(address.district) &&
                city.equals(address.city);
    }

    @Override
    public int hashCode() {
        return Objects.hash(houseNumber, ward, district, city);
    }

    @Override
    public String toString() {
        return format();
    }
}
