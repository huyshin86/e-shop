package com.example.e_shop.domain.entities;

import java.util.Objects;

import lombok.Getter;

@Getter
public class Role {
    private final Long id;
    private String name;

    // For ORM
    protected Role() {
        this.id = null;
    }

    // For creating new roles
    public Role(String name) {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Role name cannot be null or empty");
        }
        this.id = null; // ID will be set by the database
        this.name = normalizeName(name); // Normalize to "ROLE_" prefix
    }

    // Domain Behaviors
    public void changeName(String newName) {
        if (newName == null || newName.trim().isEmpty()) {
            throw new IllegalArgumentException("New name cannot be null or empty");
        }
        String normalizedName = normalizeName(newName);
        if (normalizedName.equals(this.name)) {
            throw new IllegalArgumentException("New name cannot be the same as the current name");
        }
        this.name = normalizedName;
    }

    private String normalizeName(String name){
        String cleanName = name.trim().toUpperCase();
        return cleanName.startsWith("ROLE_") ? cleanName : "ROLE_" + cleanName;
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