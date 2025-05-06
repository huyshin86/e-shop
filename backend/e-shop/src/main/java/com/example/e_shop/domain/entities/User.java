package com.example.e_shop.domain.entities;

import java.time.Instant;
import java.util.Objects;

import com.example.e_shop.domain.valueObjects.Email;
import com.example.e_shop.domain.valueObjects.UserStatus;

import lombok.Getter;

@Getter
public class User {
    private final Long id;
    private Email email;
    private String hashed_password;
    private Role role;
    private UserStatus status;
    private Instant lastLogin;
    private Instant createdAt;
    private Instant updatedAt;
    private Instant deletedAt;

    // For ORM
    protected User() {
        this.id = null;
    }

    // For creating new users
    public User(Email email, String hashed_password, Role role) {
        if (email == null) throw new IllegalArgumentException("Email can not be null!");
        if (hashed_password == null || hashed_password.trim().isEmpty()) throw new IllegalArgumentException("Password can not be empty!");
        if (role == null) throw new IllegalArgumentException("Role can not be null!");

        this.id = null;
        this.email = email;
        this.hashed_password = hashed_password;
        this.role = role;
        this.status = UserStatus.ACTIVE; // Default status
        this.lastLogin = null; // Default last login time
        this.createdAt = null; // Default created time ORM will set this
        this.updatedAt = null; // Default updated time ORM will set this
        this.deletedAt = null; // Default deleted time ORM will set this
    }

    // Domain Behaviors
    public void changeEmail(Email newEmail) {
        if (newEmail == null) {
            throw new IllegalArgumentException("New email cannot be null");
        }
        if (newEmail.equals(this.email)) {
            throw new IllegalArgumentException("New email cannot be the same as the current email");
        }
        this.email = newEmail;
    }

    public void changeRole(Role newRole) {
        if (newRole == null) {
            throw new IllegalArgumentException("New role cannot be null");
        }
        if (newRole.equals(this.role)) {
            throw new IllegalArgumentException("New role cannot be the same as the current role");
        }
        this.role = newRole;
    }
    // Used for password reset or change called by application service
    protected void setHashedPassword(String newHashed_password) {
        if (newHashed_password == null || newHashed_password.trim().isEmpty()) throw new IllegalArgumentException("Password can not be empty!");
        this.hashed_password = newHashed_password;
    }
    public void recordLogin() {
        this.lastLogin = Instant.now(); // Update last login time to now
    }
    public void recordDeletion() {
        this.deletedAt = Instant.now(); // Update deleted time to now
    }
    public boolean isDeleted() {
        return deletedAt != null && status.equals(UserStatus.INACTIVE); // Check if the user is marked as deleted
    }
    public boolean isActive() {
        return status.equals(UserStatus.ACTIVE); // Check if the user is active
    }
    public boolean isLocked() {
        return status.equals(UserStatus.LOCKED); // Check if the user is locked
    }
    public void lock() {
        if (isLocked()) {
            throw new IllegalStateException("User is already locked");
        }
        if (isDeleted()) {
            throw new IllegalStateException("User is inactive and cannot be locked");
        }
        this.status = UserStatus.LOCKED; // Set status to locked
    }
    public void unlock() {
        if (isActive()) {
            throw new IllegalStateException("User is already active");
        }
        if (isDeleted()) {
            throw new IllegalStateException("User is inactive and cannot be unlocked");
        }
        this.status = UserStatus.ACTIVE; // Set status to active
    }
    public void delete() {
        if (isLocked()) {
            throw new IllegalStateException("User is locked and cannot be deleted");
        }
        if (isDeleted()) {
            throw new IllegalStateException("User is already inactive");
        }
        recordDeletion();// Update deleted time to now
        this.status = UserStatus.INACTIVE; // Set status to inactive
    }
    public void restore() {
        if (isActive()) {
            throw new IllegalStateException("User is already active");
        }
        if (isLocked()) {
            throw new IllegalStateException("User is locked and cannot be restored");
        }
        this.deletedAt = null; // Clear deleted time
        this.status = UserStatus.ACTIVE; // Restore status to active
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false; // Check if the object is of the same class
        User user = (User) o;
        return id != null && Objects.equals(id, user.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", email='" + email +
                ", role=" + role.getName() +
                ", status=" + status +
                '}';
    }
}