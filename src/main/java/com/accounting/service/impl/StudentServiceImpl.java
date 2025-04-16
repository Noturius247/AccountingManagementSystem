package com.accounting.service.impl;

import com.accounting.model.Student;
import com.accounting.model.User;
import com.accounting.repository.StudentRepository;
import com.accounting.service.StudentService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.atomic.AtomicInteger;

@Service
public class StudentServiceImpl implements StudentService {

    private final StudentRepository studentRepository;
    private final AtomicInteger sequence = new AtomicInteger(1);

    @Autowired
    public StudentServiceImpl(StudentRepository studentRepository) {
        this.studentRepository = studentRepository;
    }

    @Override
    @Transactional
    public Student registerStudent(User user, String program, Integer yearLevel) {
        String studentId = generateStudentId(program, yearLevel);
        
        Student student = new Student();
        student.setUser(user);
        student.setStudentId(studentId);
        student.setProgram(program);
        student.setYearLevel(yearLevel);
        student.setAcademicYear(getCurrentAcademicYear());
        student.setSemester(getCurrentSemester());
        
        return studentRepository.save(student);
    }

    @Override
    public Student getStudentByStudentId(String studentId) {
        return studentRepository.findByStudentId(studentId)
            .orElseThrow(() -> new EntityNotFoundException("Student not found with ID: " + studentId));
    }

    @Override
    public Student getStudentByUser(User user) {
        return studentRepository.findByUserId(user.getId())
            .orElseThrow(() -> new EntityNotFoundException("Student not found for user: " + user.getUsername()));
    }

    @Override
    public String generateStudentId(String program, Integer yearLevel) {
        // Format: YYYY-PPPNNN
        // YYYY = Current year
        // PPP = Program code (first 3 letters)
        // NNN = Sequential number
        
        String year = String.valueOf(LocalDateTime.now().getYear());
        String programCode = program.substring(0, Math.min(program.length(), 3)).toUpperCase();
        String sequenceNumber = String.format("%03d", sequence.getAndIncrement());
        
        String studentId = year + "-" + programCode + sequenceNumber;
        
        // Check if ID exists, if so, generate a new one
        while (!isStudentIdAvailable(studentId)) {
            sequenceNumber = String.format("%03d", sequence.getAndIncrement());
            studentId = year + "-" + programCode + sequenceNumber;
        }
        
        return studentId;
    }

    @Override
    public boolean isStudentIdAvailable(String studentId) {
        return !studentRepository.existsByStudentId(studentId);
    }

    private String getCurrentAcademicYear() {
        LocalDateTime now = LocalDateTime.now();
        int year = now.getYear();
        return year + "-" + (year + 1);
    }

    private Integer getCurrentSemester() {
        LocalDateTime now = LocalDateTime.now();
        int month = now.getMonthValue();
        
        // First semester: June to October
        if (month >= 6 && month <= 10) return 1;
        // Second semester: November to March
        else if (month >= 11 || month <= 3) return 2;
        // Summer: April to May
        else return 3;
    }
} 