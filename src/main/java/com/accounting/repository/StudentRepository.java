package com.accounting.repository;

import com.accounting.model.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface StudentRepository extends JpaRepository<Student, Long> {
    Optional<Student> findByUsername(String username);
    Optional<Student> findByStudentId(String studentId);
    Optional<Student> findByUserId(Long userId);
    boolean existsByStudentId(String studentId);
    List<Student> findByRegistrationStatus(String status);
} 