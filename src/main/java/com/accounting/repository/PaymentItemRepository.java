package com.accounting.repository;

import com.accounting.model.PaymentItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PaymentItemRepository extends JpaRepository<PaymentItem, Long> {
    List<PaymentItem> findByActiveTrue();
    List<PaymentItem> findByCategory(String category);
    List<PaymentItem> findByCategoryAndActiveTrue(String category);
} 