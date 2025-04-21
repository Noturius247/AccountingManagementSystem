-- Create payments table
CREATE TABLE payments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    transaction_id VARCHAR(50) NOT NULL UNIQUE,
    user_id BIGINT NOT NULL,
    amount DECIMAL(19,2) NOT NULL,
    description VARCHAR(255) NOT NULL,
    payment_status VARCHAR(20) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    currency VARCHAR(3) DEFAULT 'PHP',
    tax_amount DECIMAL(19,2) DEFAULT 0.00,
    payment_number VARCHAR(50) NOT NULL UNIQUE,
    queue_number VARCHAR(50),
    type VARCHAR(50) NOT NULL,
    error_message TEXT,
    payment_gateway_response TEXT,
    schedule VARCHAR(50),
    schedule_id VARCHAR(50),
    receipt_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    processed_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Drop existing tables if they exist (optional, uncomment if needed)
-- DROP TABLE IF EXISTS payment_disputes;
-- DROP TABLE IF EXISTS payment_receipts;

-- Create payment_disputes table if it doesn't exist
CREATE TABLE payment_disputes (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    dispute_number VARCHAR(50) NOT NULL UNIQUE,
    payment_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    reason VARCHAR(255) NOT NULL,
    status VARCHAR(50) NOT NULL,
    priority VARCHAR(20) DEFAULT 'NORMAL',
    evidence TEXT,
    resolution TEXT,
    refund_requested BOOLEAN DEFAULT FALSE,
    refund_approved BOOLEAN DEFAULT FALSE,
    assigned_to BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL,
    FOREIGN KEY (payment_id) REFERENCES payments(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (assigned_to) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create payment_receipts table if it doesn't exist
CREATE TABLE payment_receipts (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    receipt_number VARCHAR(50) NOT NULL UNIQUE,
    payment_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    queue_number VARCHAR(50),
    terminal_id VARCHAR(50),
    service_name VARCHAR(100),
    amount DECIMAL(19,2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    receipt_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (payment_id) REFERENCES payments(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create documents table
CREATE TABLE documents (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    document_number VARCHAR(50) NOT NULL UNIQUE,
    document_type VARCHAR(50) NOT NULL,
    reference_number VARCHAR(50) NOT NULL,
    user_id BIGINT NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (reference_number) REFERENCES payments(payment_number),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Create indexes
CREATE INDEX idx_payments_user_id ON payments(user_id);
CREATE INDEX idx_payments_status ON payments(payment_status);
CREATE INDEX idx_payments_queue_number ON payments(queue_number);
CREATE INDEX idx_payments_payment_number ON payments(payment_number);
CREATE INDEX idx_payment_disputes_payment_id ON payment_disputes(payment_id);
CREATE INDEX idx_payment_disputes_user_id ON payment_disputes(user_id);
CREATE INDEX idx_payment_disputes_dispute_number ON payment_disputes(dispute_number);
CREATE INDEX idx_payment_disputes_status ON payment_disputes(status);
CREATE INDEX idx_payment_receipts_payment_id ON payment_receipts(payment_id);
CREATE INDEX idx_payment_receipts_user_id ON payment_receipts(user_id);
CREATE INDEX idx_payment_receipts_receipt_number ON payment_receipts(receipt_number);
CREATE INDEX idx_payment_receipts_queue_number ON payment_receipts(queue_number);
CREATE INDEX idx_documents_reference_number ON documents(reference_number);
CREATE INDEX idx_documents_user_id ON documents(user_id);
CREATE INDEX idx_documents_document_number ON documents(document_number);

-- Create indexes (will fail silently if they exist)
CREATE INDEX idx_payment_disputes_dispute_number ON payment_disputes(dispute_number);
CREATE INDEX idx_payment_disputes_status ON payment_disputes(status);
CREATE INDEX idx_payment_receipts_receipt_number ON payment_receipts(receipt_number);
CREATE INDEX idx_payment_receipts_queue_number ON payment_receipts(queue_number);

-- Add columns to existing payments table for payment service
ALTER TABLE payments
ADD COLUMN transaction_id VARCHAR(50) UNIQUE AFTER id,
ADD COLUMN payment_method VARCHAR(50) AFTER type,
ADD COLUMN receipt_url VARCHAR(255) AFTER payment_number,
ADD COLUMN error_message TEXT AFTER status,
ADD COLUMN payment_gateway_response TEXT AFTER error_message,
ADD COLUMN schedule VARCHAR(50) AFTER payment_gateway_response,
ADD COLUMN schedule_id VARCHAR(50) AFTER schedule,
ADD COLUMN queue_number VARCHAR(50) AFTER payment_queue_id;

-- Add columns to existing documents table for document service
ALTER TABLE documents
ADD COLUMN document_type VARCHAR(50) AFTER id,
ADD COLUMN reference_number VARCHAR(50) AFTER document_type,
ADD COLUMN user_id BIGINT AFTER reference_number,
ADD COLUMN status VARCHAR(20) DEFAULT 'ACTIVE' AFTER file_path,
ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER created_at,
ADD FOREIGN KEY (user_id) REFERENCES users(id);

-- Create additional indexes for better performance
CREATE INDEX idx_payment_transaction ON payments(transaction_id);
CREATE INDEX idx_payment_method ON payments(payment_method);
CREATE INDEX idx_payment_queue ON payments(queue_number);
CREATE INDEX idx_document_type ON documents(document_type);
CREATE INDEX idx_document_reference ON documents(reference_number);
CREATE INDEX idx_document_user ON documents(user_id); 