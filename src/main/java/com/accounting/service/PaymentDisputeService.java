package com.accounting.service;

import com.accounting.model.Payment;
import com.accounting.model.PaymentDispute;
import java.util.List;

public interface PaymentDisputeService {
    /**
     * Create a new payment dispute
     */
    PaymentDispute createDispute(Payment payment, String reason);
    
    /**
     * Update dispute status
     */
    PaymentDispute updateDisputeStatus(Long disputeId, String status);
    
    /**
     * Get all disputes for a user
     */
    List<PaymentDispute> getUserDisputes(String username);
    
    /**
     * Get dispute details
     */
    PaymentDispute getDisputeDetails(Long disputeId);
    
    /**
     * Add evidence to dispute
     */
    PaymentDispute addEvidence(Long disputeId, String evidence);
    
    /**
     * Resolve dispute
     */
    PaymentDispute resolveDispute(Long disputeId, String resolution, boolean refund);

    PaymentDispute createDispute(PaymentDispute dispute);
    PaymentDispute updateDispute(PaymentDispute dispute);
    PaymentDispute getDisputeById(Long id);
    List<PaymentDispute> getDisputesByUserId(Long userId);
    List<PaymentDispute> getDisputesByPaymentId(Long paymentId);
    List<PaymentDispute> getDisputesByStatus(String status);
} 