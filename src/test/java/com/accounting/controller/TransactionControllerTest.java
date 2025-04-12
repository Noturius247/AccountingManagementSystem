package com.accounting.controller;

import com.accounting.model.Transaction;
import com.accounting.service.TransactionService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.http.ResponseEntity;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class TransactionControllerTest {

    @Mock
    private TransactionService transactionService;

    @InjectMocks
    private TransactionController transactionController;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void getAllTransactions_ShouldReturnListOfTransactions() {
        // Arrange
        List<Transaction> expectedTransactions = Arrays.asList(
            new Transaction(),
            new Transaction()
        );
        when(transactionService.getAllTransactions()).thenReturn(expectedTransactions);

        // Act
        ResponseEntity<List<Transaction>> response = transactionController.getAllTransactions();

        // Assert
        assertEquals(200, response.getStatusCodeValue());
        assertEquals(expectedTransactions, response.getBody());
        verify(transactionService).getAllTransactions();
    }

    @Test
    void getTransaction_WhenExists_ShouldReturnTransaction() {
        // Arrange
        Long id = 1L;
        Transaction expectedTransaction = new Transaction();
        when(transactionService.getTransaction(id)).thenReturn(expectedTransaction);

        // Act
        ResponseEntity<Transaction> response = transactionController.getTransaction(id);

        // Assert
        assertEquals(200, response.getStatusCodeValue());
        assertEquals(expectedTransaction, response.getBody());
        verify(transactionService).getTransaction(id);
    }

    @Test
    void getTransaction_WhenNotExists_ShouldReturnNotFound() {
        // Arrange
        Long id = 1L;
        when(transactionService.getTransaction(id)).thenReturn(null);

        // Act
        ResponseEntity<Transaction> response = transactionController.getTransaction(id);

        // Assert
        assertEquals(404, response.getStatusCodeValue());
        verify(transactionService).getTransaction(id);
    }

    @Test
    void createTransaction_ShouldReturnCreatedTransaction() {
        // Arrange
        Transaction inputTransaction = new Transaction();
        Transaction expectedTransaction = new Transaction();
        when(transactionService.createTransaction(inputTransaction)).thenReturn(expectedTransaction);

        // Act
        ResponseEntity<Transaction> response = transactionController.createTransaction(inputTransaction);

        // Assert
        assertEquals(200, response.getStatusCodeValue());
        assertEquals(expectedTransaction, response.getBody());
        verify(transactionService).createTransaction(inputTransaction);
    }

    @Test
    void updateTransaction_WhenExists_ShouldReturnUpdatedTransaction() {
        // Arrange
        Long id = 1L;
        Transaction inputTransaction = new Transaction();
        Transaction expectedTransaction = new Transaction();
        when(transactionService.updateTransaction(id, inputTransaction)).thenReturn(expectedTransaction);

        // Act
        ResponseEntity<Transaction> response = transactionController.updateTransaction(id, inputTransaction);

        // Assert
        assertEquals(200, response.getStatusCodeValue());
        assertEquals(expectedTransaction, response.getBody());
        verify(transactionService).updateTransaction(id, inputTransaction);
    }

    @Test
    void updateTransaction_WhenNotExists_ShouldReturnNotFound() {
        // Arrange
        Long id = 1L;
        Transaction inputTransaction = new Transaction();
        when(transactionService.updateTransaction(id, inputTransaction)).thenReturn(null);

        // Act
        ResponseEntity<Transaction> response = transactionController.updateTransaction(id, inputTransaction);

        // Assert
        assertEquals(404, response.getStatusCodeValue());
        verify(transactionService).updateTransaction(id, inputTransaction);
    }

    @Test
    void deleteTransaction_ShouldReturnOk() {
        // Arrange
        Long id = 1L;

        // Act
        ResponseEntity<Void> response = transactionController.deleteTransaction(id);

        // Assert
        assertEquals(200, response.getStatusCodeValue());
        verify(transactionService).deleteTransaction(id);
    }

    @Test
    void getTransactionsByUser_ShouldReturnListOfTransactions() {
        // Arrange
        Long userId = 1L;
        List<Transaction> expectedTransactions = Arrays.asList(
            new Transaction(),
            new Transaction()
        );
        when(transactionService.getTransactionsByUser(userId)).thenReturn(expectedTransactions);

        // Act
        ResponseEntity<List<Transaction>> response = transactionController.getTransactionsByUser(userId);

        // Assert
        assertEquals(200, response.getStatusCodeValue());
        assertEquals(expectedTransactions, response.getBody());
        verify(transactionService).getTransactionsByUser(userId);
    }

    @Test
    void getTransactionStatistics_ShouldReturnStatistics() {
        // Arrange
        Map<String, Object> expectedStats = Map.of(
            "totalTransactions", 100,
            "totalAmount", new BigDecimal("1000.00")
        );
        when(transactionService.getTransactionStatistics()).thenReturn(expectedStats);

        // Act
        ResponseEntity<Map<String, Object>> response = transactionController.getTransactionStatistics();

        // Assert
        assertEquals(200, response.getStatusCodeValue());
        assertEquals(expectedStats, response.getBody());
        verify(transactionService).getTransactionStatistics();
    }

    @Test
    void getTotalAmount_ShouldReturnTotalAmount() {
        // Arrange
        String query = "date:2024-01-01";
        BigDecimal expectedAmount = new BigDecimal("1000.00");
        when(transactionService.getTotalAmount(query)).thenReturn(expectedAmount);

        // Act
        ResponseEntity<BigDecimal> response = transactionController.getTotalAmount(query);

        // Assert
        assertEquals(200, response.getStatusCodeValue());
        assertEquals(expectedAmount, response.getBody());
        verify(transactionService).getTotalAmount(query);
    }
} 