package com.accounting.model;

import com.accounting.model.enums.ReceiptPreference;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class QueuePosition {
    private int position;
    private int estimatedWaitTime;
    private String kioskSessionId;
    private String publicIdentifier;
    private String kioskTerminalId;
    private String queueNumber;
    private ReceiptPreference receiptPreference;

    public QueuePosition(int position, int estimatedWaitTime) {
        this.position = position;
        this.estimatedWaitTime = estimatedWaitTime;
    }

    public int getPosition() {
        return position;
    }

    public void setPosition(int position) {
        this.position = position;
    }

    public int getEstimatedWaitTime() {
        return estimatedWaitTime;
    }

    public void setEstimatedWaitTime(int estimatedWaitTime) {
        this.estimatedWaitTime = estimatedWaitTime;
    }

    public String getQueueNumber() {
        return queueNumber;
    }

    public void setQueueNumber(String queueNumber) {
        this.queueNumber = queueNumber;
    }

    public String getKioskSessionId() {
        return kioskSessionId;
    }

    public void setKioskSessionId(String kioskSessionId) {
        this.kioskSessionId = kioskSessionId;
    }

    public String getPublicIdentifier() {
        return publicIdentifier;
    }

    public void setPublicIdentifier(String publicIdentifier) {
        this.publicIdentifier = publicIdentifier;
    }

    public String getKioskTerminalId() {
        return kioskTerminalId;
    }

    public void setKioskTerminalId(String kioskTerminalId) {
        this.kioskTerminalId = kioskTerminalId;
    }

    public ReceiptPreference getReceiptPreference() {
        return receiptPreference;
    }

    public void setReceiptPreference(ReceiptPreference receiptPreference) {
        this.receiptPreference = receiptPreference;
    }
} 