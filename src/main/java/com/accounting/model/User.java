package com.accounting.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.HashMap;
import com.accounting.model.RegistrationStatus;

@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(columnDefinition = "bigint(20)")
    private Long id;

    @Column(nullable = false, length = 255)
    private String username;

    @Column(nullable = false, length = 255)
    private String password;

    @Column(nullable = false, length = 255)
    private String email;

    @Column(name = "first_name", length = 255)
    private String firstName;

    @Column(name = "last_name", length = 255)
    private String lastName;

    @Column(name = "phone_number", length = 20)
    private String phoneNumber;

    @Column(columnDefinition = "TEXT")
    private String address;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(columnDefinition = "tinyint(1) default 1")
    private boolean enabled = true;

    @Column(name = "account_non_expired", columnDefinition = "tinyint(1) default 1")
    private boolean accountNonExpired = true;

    @Column(name = "account_non_locked", columnDefinition = "tinyint(1) default 1")
    private boolean accountNonLocked = true;

    @Column(name = "credentials_non_expired", columnDefinition = "tinyint(1) default 1")
    private boolean credentialsNonExpired = true;

    @Column(name = "last_login", columnDefinition = "timestamp")
    private LocalDateTime lastLogin;

    @Column(name = "online_status", columnDefinition = "tinyint(1) default 0")
    private boolean onlineStatus = false;

    @Column(precision = 38, scale = 2)
    private BigDecimal balance = BigDecimal.ZERO;

    @Column(name = "last_activity")
    private LocalDateTime lastActivity;

    @Column(length = 255)
    private String role;

    @ElementCollection
    @CollectionTable(name = "user_notification_settings", joinColumns = @JoinColumn(name = "user_id"))
    @MapKeyColumn(name = "setting_key")
    @Column(name = "setting_value")
    private Map<String, String> notificationSettings = new HashMap<>();

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Transaction> transactions = new HashSet<>();

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Document> documents = new HashSet<>();

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Notification> notifications = new HashSet<>();

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Queue> queues = new HashSet<>();

    @Transient
    private boolean student;

    @Enumerated(EnumType.STRING)
    @Column(name = "registration_status", columnDefinition = "ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'PENDING'")
    private RegistrationStatus registrationStatus = RegistrationStatus.PENDING;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        lastActivity = LocalDateTime.now();
        if (role == null) {
            role = "USER";
        }
        if (balance == null) {
            balance = BigDecimal.ZERO;
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    @PostLoad
    protected void onLoad() {
        if (notificationSettings == null) {
            notificationSettings = new HashMap<>();
        }
    }

    public Long getId() {
        return id;
    }

    public String getUsername() {
        return username;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public BigDecimal getBalance() {
        return balance;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public boolean isEnabled() {
        return enabled;
    }

    public LocalDateTime getLastActivity() {
        return lastActivity;
    }

    public String getRole() {
        return role;
    }

    public Map<String, String> getNotificationSettings() {
        return notificationSettings;
    }

    public Set<Transaction> getTransactions() {
        return transactions;
    }

    public Set<Document> getDocuments() {
        return documents;
    }

    public Set<Notification> getNotifications() {
        return notifications;
    }

    public Set<Queue> getQueues() {
        return queues;
    }

    public boolean isStudent() {
        return student;
    }

    public RegistrationStatus getRegistrationStatus() {
        return registrationStatus;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public void setBalance(BigDecimal balance) {
        this.balance = balance;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }

    public void setLastActivity(LocalDateTime lastActivity) {
        this.lastActivity = lastActivity;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public void setNotificationSettings(Map<String, String> notificationSettings) {
        this.notificationSettings = notificationSettings;
    }

    public void setTransactions(Set<Transaction> transactions) {
        this.transactions = transactions;
    }

    public void setDocuments(Set<Document> documents) {
        this.documents = documents;
    }

    public void setNotifications(Set<Notification> notifications) {
        this.notifications = notifications;
    }

    public void setQueues(Set<Queue> queues) {
        this.queues = queues;
    }

    public void setStudent(boolean student) {
        this.student = student;
    }

    public void setRegistrationStatus(RegistrationStatus registrationStatus) {
        this.registrationStatus = registrationStatus;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                '}';
    }
}