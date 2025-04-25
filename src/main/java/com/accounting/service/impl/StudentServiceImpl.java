package com.accounting.service.impl;

import com.accounting.model.Student;
import com.accounting.model.User;
import com.accounting.repository.StudentRepository;
import com.accounting.repository.UserRepository;
import com.accounting.service.StudentService;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import jakarta.validation.Validator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.List;
import java.util.Set;
import java.util.Optional;

@Service
public class StudentServiceImpl implements StudentService {

    private final StudentRepository studentRepository;
    private final UserRepository userRepository;
    private final Validator validator;
    private final AtomicInteger sequence = new AtomicInteger(1);

    @Autowired
    public StudentServiceImpl(StudentRepository studentRepository, UserRepository userRepository, Validator validator) {
        this.studentRepository = studentRepository;
        this.userRepository = userRepository;
        this.validator = validator;
    }

    @Override
    @Transactional
    public Student registerStudent(User user, String program, Integer yearLevel, String academicYear, String semester, String fullName) {
        // Check if user already has a student record
        if (studentRepository.existsByUserId(user.getId())) {
            throw new IllegalStateException("User already has a student record");
        }

        String studentId = generateStudentId(program, yearLevel);
        
        Student student = new Student();
        student.setUser(user);
        student.setUsername(user.getUsername());
        student.setStudentId(studentId);
        student.setProgram(program);
        student.setYearLevel(yearLevel);
        student.setAcademicYear(academicYear);
        student.setSemester(semester);
        student.setFullName(fullName);
        student.setRegistrationStatus(Student.RegistrationStatus.PENDING);
        
        // Validate the student entity
        Set<ConstraintViolation<Student>> violations = validator.validate(student);
        if (!violations.isEmpty()) {
            throw new ConstraintViolationException(violations);
        }
        
        return studentRepository.save(student);
    }

    @Override
    @Transactional(readOnly = true)
    public Student getStudentByStudentId(String studentId) {
        return studentRepository.findByStudentId(studentId)
            .orElseThrow(() -> new EntityNotFoundException("Student not found with ID: " + studentId));
    }

    @Override
    @Transactional(readOnly = true)
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

    @Override
    public Student findByUsername(String username) {
        return studentRepository.findByUsername(username)
            .orElseThrow(() -> new EntityNotFoundException("Student not found with username: " + username));
    }

    @Override
    public Student save(Student student) {
        return studentRepository.save(student);
    }

    @Override
    public List<Student> findAll() {
        return studentRepository.findAll();
    }

    @Override
    public Student findById(Long id) {
        return studentRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException("Student not found with id: " + id));
    }

    @Override
    public void deleteById(Long id) {
        studentRepository.deleteById(id);
    }

    @Override
    public List<Student> findByRegistrationStatus(Student.RegistrationStatus status) {
        return studentRepository.findByRegistrationStatus(status);
    }

    @Override
    public Page<Student> searchStudents(String search, String status, String program, Pageable pageable) {
        if (search != null && !search.isEmpty()) {
            return studentRepository.findByFullNameContainingOrStudentIdContainingAndRegistrationStatusAndProgram(
                search, search, Student.RegistrationStatus.valueOf(status), program, pageable);
        }
        return getStudentsByStatusAndProgram(status, program, pageable);
    }

    @Override
    public Page<Student> getStudentsByStatusAndProgram(String status, String program, Pageable pageable) {
        if (status != null && program != null) {
            return studentRepository.findByRegistrationStatusAndProgram(
                Student.RegistrationStatus.valueOf(status), program, pageable);
        } else if (status != null) {
            return studentRepository.findByRegistrationStatus(
                Student.RegistrationStatus.valueOf(status), pageable);
        } else if (program != null) {
            return studentRepository.findByProgram(program, pageable);
        }
        return studentRepository.findAll(pageable);
    }

    @Override
    public Student getStudentById(Long id) {
        return studentRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Student not found with id: " + id));
    }

    @Override
    @Transactional
    public void approveStudent(Long id) {
        Student student = getStudentById(id);
        if (student.getRegistrationStatus() != Student.RegistrationStatus.PENDING) {
            throw new IllegalStateException("Only pending registrations can be approved");
        }
        student.setRegistrationStatus(Student.RegistrationStatus.APPROVED);
        
        // Update the user's role to STUDENT
        User user = student.getUser();
        user.setRole("ROLE_STUDENT");
        userRepository.save(user);
        
        studentRepository.save(student);
    }

    @Override
    @Transactional
    public void rejectStudent(Long id) {
        Student student = getStudentById(id);
        if (student.getRegistrationStatus() != Student.RegistrationStatus.PENDING) {
            throw new IllegalStateException("Only pending registrations can be rejected");
        }
        student.setRegistrationStatus(Student.RegistrationStatus.REJECTED);
        studentRepository.save(student);
    }

    @Override
    public long countByRegistrationStatus(Student.RegistrationStatus status) {
        return studentRepository.countByRegistrationStatus(status);
    }

    @Override
    @Transactional
    public void revokeApproval(Long id) {
        Student student = getStudentById(id);
        if (student.getRegistrationStatus() != Student.RegistrationStatus.APPROVED) {
            throw new IllegalStateException("Only approved registrations can be revoked");
        }
        student.setRegistrationStatus(Student.RegistrationStatus.PENDING);
        studentRepository.save(student);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Student> findByUserId(Long userId) {
        return studentRepository.findByUserId(userId);
    }
} 