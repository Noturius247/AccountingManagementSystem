package com.accounting.repository;

import com.accounting.model.Kiosk;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface KioskRepository extends JpaRepository<Kiosk, Long> {
    List<Kiosk> findByStatus(String status);
    List<Kiosk> findByLastActivityAfter(LocalDateTime time);
    List<Kiosk> findByLocationContaining(String location);
    long countByStatus(String status);
} 