package com.accounting.repository;

import com.accounting.model.PaymentDispute;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface PaymentDisputeRepository extends JpaRepository<PaymentDispute, Long> {
    List<PaymentDispute> findByUserId(Long userId);
    List<PaymentDispute> findByPaymentId(Long paymentId);
    List<PaymentDispute> findByStatus(String status);
} 