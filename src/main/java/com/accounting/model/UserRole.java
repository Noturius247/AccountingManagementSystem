package com.accounting.model;

import jakarta.persistence.*;
import lombok.Data;
import java.io.Serializable;
import java.util.Objects;

@Data
@Entity
@Table(name = "user_roles")
public class UserRole implements Serializable {
    @EmbeddedId
    private UserRoleId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("userId")
    @JoinColumn(name = "user_id")
    private User user;

    // Default constructor
    public UserRole() {
    }

    // Constructor with user and role
    public UserRole(User user, String role) {
        this.user = user;
        this.id = new UserRoleId(user.getId(), role);
    }

    // Getters and setters
    public UserRoleId getId() {
        return id;
    }

    public void setId(UserRoleId id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getRole() {
        return id != null ? id.getRole() : null;
    }

    public void setRole(String role) {
        if (id == null) {
            id = new UserRoleId();
        }
        id.setRole(role);
    }
}

@Embeddable
class UserRoleId implements Serializable {
    private static final long serialVersionUID = 1L;

    @Column(name = "user_id")
    private Long userId;

    @Column(name = "role")
    private String role;

    public UserRoleId() {
    }

    public UserRoleId(Long userId, String role) {
        this.userId = userId;
        this.role = role;
    }

    // Getters and setters
    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        UserRoleId that = (UserRoleId) o;
        return Objects.equals(userId, that.userId) &&
               Objects.equals(role, that.role);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, role);
    }
} 