package com.accounting.repository;

import com.accounting.model.ReceiptTemplate;
import com.accounting.model.enums.ReceiptTemplateType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface ReceiptTemplateRepository extends JpaRepository<ReceiptTemplate, Long> {
    Optional<ReceiptTemplate> findByName(String name);
    List<ReceiptTemplate> findByType(ReceiptTemplateType type);
    List<ReceiptTemplate> findByActiveTrue();
    Optional<ReceiptTemplate> findByNameAndActiveTrue(String name);
} 