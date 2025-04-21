package com.accounting.service;

import com.accounting.model.Manager;
import com.accounting.model.Student;
import com.accounting.repository.ManagerRepository;
import com.accounting.repository.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import jakarta.persistence.EntityNotFoundException;

import java.util.List;
import java.util.Optional;

@Service
public class ManagerService {

    private final ManagerRepository managerRepository;
    private final StudentRepository studentRepository;

    @Autowired
    public ManagerService(ManagerRepository managerRepository, StudentRepository studentRepository) {
        this.managerRepository = managerRepository;
        this.studentRepository = studentRepository;
    }

    public List<Manager> getAllManagers() {
        return managerRepository.findAll();
    }

    public Optional<Manager> getManagerById(Long id) {
        return managerRepository.findById(id);
    }

    public Manager saveManager(Manager manager) {
        return managerRepository.save(manager);
    }

    public void deleteManager(Long id) {
        managerRepository.deleteById(id);
    }

    @Transactional
    public void assignStudentsToManager(Long managerId, List<Long> studentIds) {
        Manager manager = managerRepository.findById(managerId)
                .orElseThrow(() -> new EntityNotFoundException("Manager not found with ID: " + managerId));

        List<Student> students = studentRepository.findAllById(studentIds);
        if (students.size() != studentIds.size()) {
            throw new EntityNotFoundException("Some students were not found");
        }

        students.forEach(student -> student.setManager(manager));
        studentRepository.saveAll(students);
    }

    public List<Student> getStudentsByManager(Long managerId) {
        return studentRepository.findByManagerId(managerId);
    }

    public Page<Manager> searchManagers(String term, String status, Pageable pageable) {
        if (term != null && !term.isEmpty()) {
            return managerRepository.findByNameContainingIgnoreCase(term, pageable);
        }
        return managerRepository.findAll(pageable);
    }

    public Page<Manager> findAllManagers(Pageable pageable) {
        return managerRepository.findAll(pageable);
    }

    public Manager createManager(Manager manager) {
        return managerRepository.save(manager);
    }

    public Manager updateManager(Long id, Manager manager) {
        if (!managerRepository.existsById(id)) {
            throw new EntityNotFoundException("Manager not found with ID: " + id);
        }
        manager.setId(id);
        return managerRepository.save(manager);
    }
} 