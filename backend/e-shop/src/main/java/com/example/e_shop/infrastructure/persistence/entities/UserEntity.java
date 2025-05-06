package com.example.e_shop.infrastructure.persistence.entities;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Table;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

import java.time.Instant;
import java.util.Objects;

import jakarta.persistence.Column;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter(AccessLevel.PACKAGE)
@Entity
@Table(name = "users")
public class UserEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Long id;

    @Column(name = "email", unique = true, nullable = false)
    private String email;

    @Column(name = "password_hash", nullable = false)
    private String hashedPassword;

    @ManyToOne(fetch = FetchType.EAGER, optional = false)
    @JoinColumn(name = "role_id", nullable = false)
    private RoleEntity role;

    @Column(name = "status", nullable = false)
    private String status;

    @Column(name = "last_login")
    private Instant lastLogin;
    @Column(name = "create_at", nullable = false, updatable = false, insertable = false)
    private Instant createdAt;
    @Column(name = "updated_at", nullable = false, updatable = false, insertable = false)
    private Instant updatedAt;
    @Column(name = "deleted_at")
    private Instant deletedAt;

    // For ORM
    protected UserEntity() {
        this.id = null;
    }

    // For creating new users
    protected UserEntity(String email, String hashedPassword, RoleEntity role) {
        this.id = null;
        this.email = email;
        this.hashedPassword = hashedPassword;
        this.role = role;
        this.status = "active"; // Default status
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        UserEntity user = (UserEntity) o;
        return id != null && Objects.equals(id, user.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    @Override
    public String toString() {
        return "UserEntity{" +
                "id=" + id +
                ", email=" + email +
                ", role=" + role +
                ", status=" + status +
                ", last_login=" + lastLogin +
                ", created_at=" + createdAt +
                ", updated_at=" + updatedAt +
                ", deleted_at=" + deletedAt +
                '}';
    }
}
