package com.accounting.repository;

import com.accounting.model.Manager;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ManagerRepository extends JpaRepository<Manager, Long> {
    Page<Manager> findByNameContainingIgnoreCase(String name, Pageable pageable);
} 