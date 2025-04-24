package com.accounting.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.accounting.service.KioskService;
import com.accounting.service.QueueService;
import com.accounting.service.PdfService;
import com.accounting.model.Queue;
import com.accounting.model.enums.QueueStatus;
import com.accounting.model.enums.QueueType;
import com.accounting.model.enums.Priority;
import com.accounting.model.User;
import com.accounting.repository.QueueRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.math.BigDecimal;
import com.accounting.model.Payment;
import com.accounting.model.enums.PaymentStatus;
import com.accounting.model.enums.PaymentType;
import com.accounting.service.PaymentService;
import com.accounting.repository.UserRepository;
import com.accounting.repository.StudentRepository;
import com.accounting.model.Student;
import com.accounting.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import com.accounting.model.QueuePosition;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.http.HttpStatus;
import com.accounting.exception.ErrorResponse;
import java.time.LocalDateTime;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ContentDisposition;
import java.time.format.DateTimeFormatter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
@RequestMapping("/kiosk")
public class KioskController {

    private static final Logger logger = LoggerFactory.getLogger(KioskController.class);

    @Autowired
    private KioskService kioskService;

    @Autowired
    private QueueService queueService;

    @Autowired
    private QueueRepository queueRepository;

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private UserService userService;

    @Autowired
    private PdfService pdfService;

    @GetMapping("")
    public String showKiosk() {
        return "features/kiosk";
    }

    @GetMapping("/payment/{type}")
    public String showPaymentForm(@PathVariable String type) {
        switch(type) {
            case "enrollment":
                return "features/enrollment-payment";
            case "tuition":
                return "features/tuition-payment";
            case "library":
                return "features/library-payment";
            case "lab":
                return "features/lab-payment";
            case "id":
                return "features/id-payment";
            case "graduation":
                return "features/graduation-payment";
            case "transcript":
                return "features/transcript-payment";
            default:
                return "redirect:/kiosk";
        }
    }

    @GetMapping("/queue")
    public String showQueue(Authentication authentication) {
        if (authentication != null && authentication.isAuthenticated()) {
            return "features/queue";
        }
        return "redirect:/kiosk/queue/status";
    }

    @GetMapping("/queue/status")
    public String showQueueStatus(Model model) {
        // Get the current processing number (the queue number being served)
        Queue currentQueue = queueRepository.findFirstByStatusOrderByPositionAsc(QueueStatus.PROCESSING)
            .orElse(queueRepository.findFirstByStatusOrderByPositionAsc(QueueStatus.WAITING)
                .orElse(null));
            
        if (currentQueue != null) {
            model.addAttribute("currentProcessingNumber", currentQueue.getQueueNumber());
        } else {
            model.addAttribute("currentProcessingNumber", "No queue being processed");
        }
        
        return "features/kiosk-status";
    }

    @GetMapping("/help")
    public String showHelp() {
        return "features/help";
    }

    @GetMapping("/queue/new")
    public String generateQueueNumber(@RequestParam Long paymentItemId) {
        String queueNumber = queueService.generateQueueNumber();
        queueService.createQueueEntry(queueNumber, paymentItemId);
        return "redirect:/kiosk/queue/status?number=" + queueNumber;
    }

    @GetMapping("/payment/details/{id}")
    public String paymentDetails(@PathVariable Long id, Model model) {
        model.addAttribute("paymentItem", kioskService.getPaymentItem(id));
        return "features/kiosk-payment";
    }

    @GetMapping("/search")
    public String searchPayments(@RequestParam String query, Model model) {
        model.addAttribute("searchResults", kioskService.searchPaymentItems(query));
        return "features/kiosk-search";
    }

    @GetMapping("/transactions")
    public String viewTransactions(Model model) {
        // Add transaction data to model
        return "features/kiosk-transactions";
    }

    @GetMapping("/payments")
    public String viewPayments(Model model) {
        // Add payment data to model
        return "features/kiosk-payments";
    }

    private static class QueueResponse {
        private QueuePosition data;
        private ErrorResponse error;

        public QueueResponse(QueuePosition data) {
            this.data = data;
        }

        public QueueResponse(ErrorResponse error) {
            this.error = error;
        }
    }

    @GetMapping("/queue-status")
    @ResponseBody
    public ResponseEntity<Object> getQueueStatus(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            // For public users, only return current processing number
            Queue currentQueue = queueRepository.findFirstByStatusOrderByPositionAsc(QueueStatus.PROCESSING)
                .orElse(queueRepository.findFirstByStatusOrderByPositionAsc(QueueStatus.WAITING)
                    .orElse(null));
            
            Map<String, Object> response = new HashMap<>();
            response.put("currentProcessingNumber", currentQueue != null ? currentQueue.getQueueNumber() : "No queue being processed");
            return ResponseEntity.ok(response);
        }
        
        try {
            String username = authentication.getName();
            User user = userService.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
            
            // Check if user is in queue
            Optional<Queue> userQueue = queueRepository.findByUserUsername(username);
            if (userQueue.isPresent()) {
                Queue queue = userQueue.get();
                Map<String, Object> response = new HashMap<>();
                response.put("queueNumber", queue.getQueueNumber());
                response.put("position", queue.getPosition());
                response.put("estimatedWaitTime", queue.getEstimatedWaitTime());
                response.put("status", "ACTIVE");
                return ResponseEntity.ok(response);
            } else {
                // User is not in queue
                Map<String, Object> response = new HashMap<>();
                response.put("queueNumber", "");
                response.put("position", 0);
                response.put("estimatedWaitTime", 0);
                response.put("status", "INACTIVE");
                return ResponseEntity.ok(response);
            }
        } catch (Exception e) {
            return new ResponseEntity<Object>(new ErrorResponse(
                LocalDateTime.now(),
                HttpStatus.INTERNAL_SERVER_ERROR.value(),
                "Internal Server Error",
                e.getMessage(),
                "/kiosk/queue-status"
            ), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/cancel-queue")
    @ResponseBody
    public Map<String, Object> cancelQueue(@RequestParam String number, Authentication authentication) {
        Map<String, Object> response = new HashMap<>();
        if (authentication == null || !authentication.isAuthenticated()) {
            response.put("success", false);
            response.put("error", "Authentication required to cancel queue");
            return response;
        }
        
        try {
            queueService.cancelQueue(number);
            response.put("success", true);
            response.put("message", "Queue cancelled successfully");
        } catch (Exception e) {
            response.put("success", false);
            response.put("error", e.getMessage());
        }
        return response;
    }

    @GetMapping("/payment/confirmation/{id}")
    public String showPaymentConfirmation(@PathVariable Long id, Model model) {
        Payment payment = paymentService.getPaymentById(id);
        model.addAttribute("payment", payment);
        return "features/payment-confirmation";
    }

    @GetMapping("/payment/{id}/download-receipt")
    public ResponseEntity<byte[]> downloadReceipt(@PathVariable Long id) {
        try {
            Payment payment = paymentService.getPaymentById(id);
            if (payment == null || payment.getPaymentStatus() != PaymentStatus.PROCESSED) {
                return ResponseEntity.notFound().build();
            }

            // Generate receipt content
            String receiptContent = generateReceiptContent(payment);
            byte[] pdfContent = pdfService.generatePdf(receiptContent);

            // Set up response headers for PDF download
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_PDF);
            headers.setContentDisposition(ContentDisposition.builder("attachment")
                .filename("receipt_" + payment.getPaymentNumber() + ".pdf")
                .build());

            return ResponseEntity.ok()
                .headers(headers)
                .body(pdfContent);
        } catch (Exception e) {
            logger.error("Error generating receipt PDF", e);
            return ResponseEntity.internalServerError().build();
        }
    }

    private String generateReceiptContent(Payment payment) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        StringBuilder receipt = new StringBuilder();
        
        receipt.append("=================================\n");
        receipt.append("         PAYMENT RECEIPT         \n");
        receipt.append("=================================\n\n");
        
        receipt.append("Transaction ID: ").append(payment.getTransactionId()).append("\n");
        receipt.append("Date: ").append(payment.getProcessedAt().format(formatter)).append("\n");
        receipt.append("Payment Number: ").append(payment.getPaymentNumber()).append("\n");
        receipt.append("Description: ").append(payment.getDescription()).append("\n\n");
        
        receipt.append("Amount: PHP ").append(String.format("%,.2f", payment.getAmount())).append("\n");
        if (payment.getTaxAmount().compareTo(BigDecimal.ZERO) > 0) {
            receipt.append("Tax: PHP ").append(String.format("%,.2f", payment.getTaxAmount())).append("\n");
        }
        receipt.append("Payment Method: ").append(payment.getPaymentMethod()).append("\n");
        receipt.append("Status: ").append(payment.getPaymentStatus()).append("\n\n");
        
        if (payment.getQueueNumber() != null) {
            receipt.append("Queue Number: ").append(payment.getQueueNumber()).append("\n");
        }
        
        receipt.append("=================================\n");
        receipt.append("Thank you for your payment!\n");
        receipt.append("This is your official receipt.\n");
        receipt.append("=================================");
        
        return receipt.toString();
    }

    @PostMapping("/payment/tuition/process")
    public String processTuitionPayment(
            @RequestParam String studentId,
            @RequestParam String academicYear,
            @RequestParam String semester,
            @RequestParam String amount,
            Model model) {
        try {
            // First check if student exists
            Student student = studentRepository.findByStudentId(studentId)
                .orElseThrow(() -> new EntityNotFoundException("Student ID not found. Please register first."));

            // Validate amount
            BigDecimal paymentAmount = new BigDecimal(amount);
            if (paymentAmount.compareTo(BigDecimal.ZERO) <= 0) {
                throw new IllegalArgumentException("Payment amount must be greater than 0");
            }

            // Create payment record
            Payment payment = new Payment();
            payment.setDescription("Tuition Payment - " + academicYear + " Semester " + semester);
            payment.setAmount(amount);
            payment.setPaymentStatus(PaymentStatus.PENDING);
            payment.setType(PaymentType.CASH);
            payment.setUser(student.getUser());
            payment.setPaymentMethod("KIOSK");
            payment.setTransactionReference("TUI-" + System.currentTimeMillis());
            
            // Process the payment
            Payment processedPayment = paymentService.processPayment(payment);
            
            // Generate queue number
            String queueNumber = queueService.generateQueueNumber();
            queueService.createQueueEntry(queueNumber, processedPayment.getId());
            
            // Add payment details to model for confirmation
            model.addAttribute("payment", processedPayment);
            model.addAttribute("queueNumber", queueNumber);
            model.addAttribute("student", student);
            
            return "features/payment-confirmation";
        } catch (Exception e) {
            model.addAttribute("error", "Failed to process payment: " + e.getMessage());
            model.addAttribute("studentId", studentId);
            model.addAttribute("academicYear", academicYear);
            model.addAttribute("semester", semester);
            model.addAttribute("amount", amount);
            return "features/tuition-payment";
        }
    }

    @PostMapping("/verify-student")
    @ResponseBody
    public Map<String, Object> verifyStudent(@RequestParam String studentId) {
        Map<String, Object> response = new HashMap<>();
        try {
            Student student = studentRepository.findByStudentId(studentId)
                .orElseThrow(() -> new EntityNotFoundException("Student not found"));
            response.put("success", true);
            response.put("studentName", student.getUser().getUsername());
            response.put("program", student.getProgram());
            response.put("yearLevel", student.getYearLevel());
        } catch (Exception e) {
            response.put("success", false);
            response.put("error", "Invalid Student ID");
        }
        return response;
    }

    @PostMapping("/payment/library/process")
    public String processLibraryPayment(
            @RequestParam String studentId,
            @RequestParam String studentName,
            @RequestParam(defaultValue = "500.00") String amount,
            Model model) {
        try {
            Student student = studentRepository.findByStudentId(studentId)
                .orElseThrow(() -> new EntityNotFoundException("Student ID not found. Please register first."));

            BigDecimal paymentAmount = new BigDecimal(amount);
            if (paymentAmount.compareTo(BigDecimal.ZERO) <= 0) {
                throw new IllegalArgumentException("Payment amount must be greater than 0");
            }

            Payment payment = new Payment();
            payment.setDescription("Library Fee Payment");
            payment.setAmount(amount);
            payment.setPaymentStatus(PaymentStatus.PENDING);
            payment.setType(PaymentType.CASH);
            payment.setUser(student.getUser());
            payment.setPaymentMethod("KIOSK");
            payment.setTransactionReference("LIB-" + System.currentTimeMillis());
            
            Payment processedPayment = paymentService.processPayment(payment);
            String queueNumber = queueService.generateQueueNumber();
            queueService.createQueueEntry(queueNumber, processedPayment.getId());
            
            return "redirect:/kiosk/queue/status?number=" + queueNumber;
        } catch (Exception e) {
            model.addAttribute("error", "Failed to process payment: " + e.getMessage());
            model.addAttribute("studentId", studentId);
            model.addAttribute("studentName", studentName);
            model.addAttribute("amount", amount);
            return "features/library-payment";
        }
    }

    @PostMapping("/payment/lab/process")
    public String processLabPayment(
            @RequestParam String studentId,
            @RequestParam String studentName,
            @RequestParam String labType,
            @RequestParam(defaultValue = "1500.00") String amount,
            Model model) {
        try {
            Student student = studentRepository.findByStudentId(studentId)
                .orElseThrow(() -> new EntityNotFoundException("Student ID not found. Please register first."));

            BigDecimal paymentAmount = new BigDecimal(amount);
            if (paymentAmount.compareTo(BigDecimal.ZERO) <= 0) {
                throw new IllegalArgumentException("Payment amount must be greater than 0");
            }

            Payment payment = new Payment();
            payment.setDescription("Laboratory Fee Payment - " + labType);
            payment.setAmount(amount);
            payment.setPaymentStatus(PaymentStatus.PENDING);
            payment.setType(PaymentType.CASH);
            payment.setUser(student.getUser());
            payment.setPaymentMethod("KIOSK");
            payment.setTransactionReference("LAB-" + System.currentTimeMillis());
            
            Payment processedPayment = paymentService.processPayment(payment);
            String queueNumber = queueService.generateQueueNumber();
            queueService.createQueueEntry(queueNumber, processedPayment.getId());
            
            return "redirect:/kiosk/queue/status?number=" + queueNumber;
        } catch (Exception e) {
            model.addAttribute("error", "Failed to process payment: " + e.getMessage());
            model.addAttribute("studentId", studentId);
            model.addAttribute("studentName", studentName);
            model.addAttribute("labType", labType);
            model.addAttribute("amount", amount);
            return "features/lab-payment";
        }
    }

    @PostMapping("/payment/id/process")
    public String processIdPayment(
            @RequestParam String studentId,
            @RequestParam String studentName,
            @RequestParam String reason,
            @RequestParam(defaultValue = "150.00") String amount,
            Model model) {
        try {
            Student student = studentRepository.findByStudentId(studentId)
                .orElseThrow(() -> new EntityNotFoundException("Student ID not found. Please register first."));

            BigDecimal paymentAmount = new BigDecimal(amount);
            if (paymentAmount.compareTo(BigDecimal.ZERO) <= 0) {
                throw new IllegalArgumentException("Payment amount must be greater than 0");
            }

            Payment payment = new Payment();
            payment.setDescription("ID Replacement - " + reason);
            payment.setAmount(amount);
            payment.setPaymentStatus(PaymentStatus.PENDING);
            payment.setType(PaymentType.CASH);
            payment.setUser(student.getUser());
            payment.setPaymentMethod("KIOSK");
            payment.setTransactionReference("ID-" + System.currentTimeMillis());
            
            Payment processedPayment = paymentService.processPayment(payment);
            String queueNumber = queueService.generateQueueNumber();
            queueService.createQueueEntry(queueNumber, processedPayment.getId());
            
            return "redirect:/kiosk/queue/status?number=" + queueNumber;
        } catch (Exception e) {
            model.addAttribute("error", "Failed to process payment: " + e.getMessage());
            model.addAttribute("studentId", studentId);
            model.addAttribute("studentName", studentName);
            model.addAttribute("reason", reason);
            model.addAttribute("amount", amount);
            return "features/id-payment";
        }
    }

    @PostMapping("/payment/graduation/process")
    public String processGraduationPayment(
            @RequestParam String studentId,
            @RequestParam String studentName,
            @RequestParam String graduationType,
            @RequestParam(defaultValue = "3000.00") String amount,
            Model model) {
        try {
            Student student = studentRepository.findByStudentId(studentId)
                .orElseThrow(() -> new EntityNotFoundException("Student ID not found. Please register first."));

            BigDecimal paymentAmount = new BigDecimal(amount);
            if (paymentAmount.compareTo(BigDecimal.ZERO) <= 0) {
                throw new IllegalArgumentException("Payment amount must be greater than 0");
            }

            Payment payment = new Payment();
            payment.setDescription("Graduation Fee - " + graduationType);
            payment.setAmount(amount);
            payment.setPaymentStatus(PaymentStatus.PENDING);
            payment.setType(PaymentType.CASH);
            payment.setUser(student.getUser());
            payment.setPaymentMethod("KIOSK");
            payment.setTransactionReference("GRAD-" + System.currentTimeMillis());
            
            Payment processedPayment = paymentService.processPayment(payment);
            String queueNumber = queueService.generateQueueNumber();
            queueService.createQueueEntry(queueNumber, processedPayment.getId());
            
            return "redirect:/kiosk/queue/status?number=" + queueNumber;
        } catch (Exception e) {
            model.addAttribute("error", "Failed to process payment: " + e.getMessage());
            model.addAttribute("studentId", studentId);
            model.addAttribute("studentName", studentName);
            model.addAttribute("graduationType", graduationType);
            model.addAttribute("amount", amount);
            return "features/graduation-payment";
        }
    }

    @PostMapping("/payment/transcript/process")
    public String processTranscriptPayment(
            @RequestParam String studentId,
            @RequestParam String studentName,
            @RequestParam Integer copies,
            @RequestParam(defaultValue = "200.00") String amount,
            Model model) {
        try {
            Student student = studentRepository.findByStudentId(studentId)
                .orElseThrow(() -> new EntityNotFoundException("Student ID not found. Please register first."));

            BigDecimal paymentAmount = new BigDecimal(amount);
            if (paymentAmount.compareTo(BigDecimal.ZERO) <= 0) {
                throw new IllegalArgumentException("Payment amount must be greater than 0");
            }

            Payment payment = new Payment();
            payment.setDescription("Transcript Request - " + copies + " copies");
            payment.setAmount(amount);
            payment.setPaymentStatus(PaymentStatus.PENDING);
            payment.setType(PaymentType.CASH);
            payment.setUser(student.getUser());
            payment.setPaymentMethod("KIOSK");
            payment.setTransactionReference("TOR-" + System.currentTimeMillis());
            
            Payment processedPayment = paymentService.processPayment(payment);
            String queueNumber = queueService.generateQueueNumber();
            queueService.createQueueEntry(queueNumber, processedPayment.getId());
            
            return "redirect:/kiosk/queue/status?number=" + queueNumber;
        } catch (Exception e) {
            model.addAttribute("error", "Failed to process payment: " + e.getMessage());
            model.addAttribute("studentId", studentId);
            model.addAttribute("studentName", studentName);
            model.addAttribute("copies", copies);
            model.addAttribute("amount", amount);
            return "features/transcript-payment";
        }
    }

    @PostMapping("/payment/cancel/{id}")
    @ResponseBody
    public Map<String, Object> cancelPayment(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        try {
            Payment payment = paymentService.getPaymentById(id);
            if (payment.getPaymentStatus() == PaymentStatus.PENDING) {
                paymentService.cancelPayment(id);
                response.put("success", true);
                response.put("message", "Payment cancelled successfully");
            } else {
                response.put("success", false);
                response.put("error", "Only pending payments can be cancelled");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("error", e.getMessage());
        }
        return response;
    }

    @PostMapping("/payment/enrollment/process")
    public String processEnrollmentPayment(
            @RequestParam String fullName,
            @RequestParam String email,
            @RequestParam String contactNumber,
            @RequestParam String program,
            @RequestParam String academicYear,
            @RequestParam String semester,
            @RequestParam String amount,
            Model model) {
        try {
            // Create a unique applicant ID that will be used during registration
            String applicantId = "APL-" + System.currentTimeMillis() + "-" + fullName.replaceAll("\\s+", "").substring(0, Math.min(fullName.length(), 5)).toUpperCase();

            // Create a temporary reference number for the enrollment
            String enrollmentRef = "ENR-" + System.currentTimeMillis();

            // Create payment record without student association
            Payment payment = new Payment();
            payment.setDescription("New Student Enrollment - " + program + " (" + academicYear + " " + semester + ")");
            payment.setAmount(amount);
            payment.setPaymentStatus(PaymentStatus.PENDING);
            payment.setType(PaymentType.CASH);
            payment.setPaymentMethod("KIOSK");
            payment.setTransactionReference(enrollmentRef);
            
            // Store applicant information in payment metadata
            Map<String, String> metadata = new HashMap<>();
            metadata.put("applicantId", applicantId);  // Add applicant ID to metadata
            metadata.put("fullName", fullName);
            metadata.put("email", email);
            metadata.put("contactNumber", contactNumber);
            metadata.put("program", program);
            metadata.put("academicYear", academicYear);
            metadata.put("semester", semester);
            metadata.put("paymentStatus", "ENROLLMENT_PAID");  // Add payment status for registration
            payment.setMetadata(metadata);
            
            // Process the payment
            Payment processedPayment = paymentService.processPayment(payment);
            
            // Generate queue number
            String queueNumber = queueService.generateQueueNumber();
            queueService.createQueueEntry(queueNumber, processedPayment.getId());
            
            // Add payment details to model for confirmation
            model.addAttribute("payment", processedPayment);
            model.addAttribute("queueNumber", queueNumber);
            model.addAttribute("enrollmentRef", enrollmentRef);
            
            return "features/payment-confirmation";
        } catch (Exception e) {
            model.addAttribute("error", "Failed to process payment: " + e.getMessage());
            model.addAttribute("fullName", fullName);
            model.addAttribute("email", email);
            model.addAttribute("contactNumber", contactNumber);
            model.addAttribute("program", program);
            model.addAttribute("academicYear", academicYear);
            model.addAttribute("semester", semester);
            model.addAttribute("amount", amount);
            return "features/enrollment-payment";
        }
    }
} 