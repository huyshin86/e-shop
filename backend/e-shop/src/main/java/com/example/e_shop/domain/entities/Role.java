package com.example.e_shop.domain.entities;

import java.util.Objects;

import lombok.Getter;

@Getter
public class Role {
    private Long id;
    private String name;

    public Role() {
    }

    // For creating new roles
    public Role(String name) {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Role name cannot be null or empty");
        }
        this.name = name.toLowerCase(); // Normalize to lowercase
    }

    // Domain Behaviors
    public void changeName(String newName) {
        if (newName == null || newName.trim().isEmpty()) {
            throw new IllegalArgumentException("New name cannot be null or empty");
        }
        if (newName.equals(this.name)) {
            throw new IllegalArgumentException("New name cannot be the same as the current name");
        }
        this.name = newName.toLowerCase();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false; // Check if the object is of the same class
        Role role = (Role) o;
        return id != null && Objects.equals(id, role.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    @Override
    public String toString() {
        return "Role{" +
                "id=" + id +
                ", name='" + name +
                '}';
    }
}