package com.accounting.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "students")
@NoArgsConstructor
@AllArgsConstructor
public class Student {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Username is required")
    @Column(nullable = false, unique = true)
    private String username;

    @NotBlank(message = "Full name is required")
    @Column(nullable = false)
    private String fullName;

    @NotBlank(message = "Student ID is required")
    @Pattern(regexp = "^\\d{4}-[A-Z]{3}\\d{3}$", message = "Student ID must be in format YYYY-PPPNNN")
    @Column(nullable = false, unique = true)
    private String studentId;

    @NotNull
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "manager_id")
    private Manager manager;

    @NotBlank(message = "Program is required")
    @Column(nullable = false)
    private String program;

    @NotNull(message = "Year level is required")
    @Column(nullable = false)
    private Integer yearLevel;

    @Column(length = 50)
    private String section;

    @NotBlank(message = "Academic year is required")
    @Column(nullable = false)
    private String academicYear;

    @NotBlank(message = "Semester is required")
    @Column(nullable = false)
    private String semester;

    @NotNull(message = "Registration status is required")
    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private RegistrationStatus registrationStatus;

    @Column(nullable = false)
    private LocalDateTime createdAt;

    @Column(nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (registrationStatus == null) {
            registrationStatus = RegistrationStatus.PENDING;
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    public enum RegistrationStatus {
        PENDING,
        APPROVED,
        REJECTED
    }

    public User getUser() {
        return user;
    }

    public String getFullName() {
        return fullName;
    }

    public String getStudentId() {
        return studentId;
    }

    public void setManager(Manager manager) {
        this.manager = manager;
    }

    public Manager getManager() {
        return manager;
    }

    public RegistrationStatus getRegistrationStatus() {
        return registrationStatus;
    }

    public void setRegistrationStatus(RegistrationStatus registrationStatus) {
        this.registrationStatus = registrationStatus;
    }

    public String getProgram() {
        return program;
    }

    public Integer getYearLevel() {
        return yearLevel;
    }

    public String getAcademicYear() {
        return academicYear;
    }

    public String getSemester() {
        return semester;
    }

    public String getSection() {
        return section;
    }

    public void setSection(String section) {
        this.section = section;
    }

    public Long getId() {
        return id;
    }

    @Override
    public String toString() {
        return "Student{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", fullName='" + fullName + '\'' +
                ", studentId='" + studentId + '\'' +
                ", program='" + program + '\'' +
                ", yearLevel=" + yearLevel +
                ", section='" + section + '\'' +
                '}';
    }
} 