package com.accounting.service;

import com.accounting.model.Student;
import com.accounting.model.User;
import java.util.List;

public interface StudentService {
    Student registerStudent(User user, String program, Integer yearLevel);
    Student getStudentByStudentId(String studentId);
    Student getStudentByUser(User user);
    String generateStudentId(String program, Integer yearLevel);
    boolean isStudentIdAvailable(String studentId);
    Student findByUsername(String username);
    Student save(Student student);
    List<Student> findAll();
    Student findById(Long id);
    void deleteById(Long id);
    List<Student> findByRegistrationStatus(String status);
} 