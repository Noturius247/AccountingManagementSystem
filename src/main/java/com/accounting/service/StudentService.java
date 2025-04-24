package com.accounting.service;

import com.accounting.model.Student;
import com.accounting.model.User;
import java.util.List;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface StudentService {
    Student registerStudent(User user, String program, Integer yearLevel, String academicYear, String semester, String fullName);
    Student getStudentByStudentId(String studentId);
    Student getStudentByUser(User user);
    String generateStudentId(String program, Integer yearLevel);
    boolean isStudentIdAvailable(String studentId);
    Student findByUsername(String username);
    Student save(Student student);
    List<Student> findAll();
    Student findById(Long id);
    void deleteById(Long id);
    List<Student> findByRegistrationStatus(Student.RegistrationStatus status);
    long countByRegistrationStatus(Student.RegistrationStatus status);
    Page<Student> searchStudents(String search, String status, String program, Pageable pageable);
    Page<Student> getStudentsByStatusAndProgram(String status, String program, Pageable pageable);
    Student getStudentById(Long id);
    void approveStudent(Long id);
    void rejectStudent(Long id);
    void revokeApproval(Long id);
} 