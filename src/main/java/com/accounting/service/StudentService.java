package com.accounting.service;

import com.accounting.model.Student;
import com.accounting.model.User;

public interface StudentService {
    Student registerStudent(User user, String program, Integer yearLevel);
    Student getStudentByStudentId(String studentId);
    Student getStudentByUser(User user);
    String generateStudentId(String program, Integer yearLevel);
    boolean isStudentIdAvailable(String studentId);
} 