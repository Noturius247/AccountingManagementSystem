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
            @RequestParam(required = false) String notes,
            Model model) {
        try {
            logger.debug("Processing tuition payment request for student: {}", studentId);
            // Input validation
            if (studentId == null || studentId.trim().isEmpty()) {
                model.addAttribute("error", "Student ID is required");
                return "features/tuition-payment";
            }

            // Academic Year validation
            if (!isValidAcademicYear(academicYear)) {
                model.addAttribute("error", "Invalid Academic Year format. Expected format: YYYY-YYYY");
                return "features/tuition-payment";
            }

            // Semester validation
            if (!isValidSemester(semester)) {
                model.addAttribute("error", "Invalid Semester. Must be FIRST, SECOND, or SUMMER");
                return "features/tuition-payment";
            }

            // Amount validation
            BigDecimal paymentAmount;
            try {
                paymentAmount = new BigDecimal(amount);
                if (paymentAmount.compareTo(BigDecimal.ZERO) <= 0) {
                    model.addAttribute("error", "Payment amount must be greater than 0");
                    return "features/tuition-payment";
                }
            } catch (NumberFormatException e) {
                model.addAttribute("error", "Invalid amount format");
                return "features/tuition-payment";
            }

            // Student validation
            Student student;
            try {
                student = studentRepository.findByStudentId(studentId)
                .orElseThrow(() -> new EntityNotFoundException("Student ID not found. Please register first."));

                // Validate if semester matches student's current semester
                if (!semester.equals(student.getSemester())) {
                    model.addAttribute("error", "Selected semester does not match student's current semester: " + student.getSemester());
                    return "features/tuition-payment";
                }

                // Validate if academic year matches student's current academic year
                if (!academicYear.equals(student.getAcademicYear())) {
                    model.addAttribute("error", "Selected academic year does not match student's current academic year: " + student.getAcademicYear());
                    return "features/tuition-payment";
                }

            } catch (EntityNotFoundException e) {
                model.addAttribute("error", e.getMessage());
                return "features/tuition-payment";
            }

            try {
                // Create temporary payment object (not saved to database)
                Payment payment = Payment.builder()
                    .description("Tuition Payment - " + academicYear + " Semester " + semester)
                    .amount(paymentAmount)
                    .type(PaymentType.CASH)
                    .user(student.getUser())
                    .paymentMethod("KIOSK")
                    .transactionReference("TUI-" + System.currentTimeMillis())
                    .notes(notes != null ? notes.trim() : null)
                    .build();
                
                model.addAttribute("payment", payment);
                model.addAttribute("student", student);
                
                return "features/payment-confirmation";
            } catch (Exception e) {
                logger.error("Error preparing payment: {}", e.getMessage());
                model.addAttribute("error", "Error preparing payment. Please try again.");
                return "features/tuition-payment";
            }
        } catch (Exception e) {
            logger.error("Unexpected error in tuition payment: {}", e.getMessage());
            model.addAttribute("error", "An unexpected error occurred. Please try again later.");
            // Preserve form data
            model.addAttribute("studentId", studentId);
            model.addAttribute("academicYear", academicYear);
            model.addAttribute("semester", semester);
            model.addAttribute("amount", amount);
            model.addAttribute("notes", notes);
            return "features/tuition-payment";
        }
    }

    private boolean isValidAcademicYear(String academicYear) {
        if (academicYear == null || academicYear.trim().isEmpty()) {
            return false;
        }
        // Check format YYYY-YYYY
        String[] years = academicYear.split("-");
        if (years.length != 2) {
            return false;
        }
        try {
            int firstYear = Integer.parseInt(years[0]);
            int secondYear = Integer.parseInt(years[1]);
            // Validate year range and that second year is one more than first year
            return firstYear >= 2000 && firstYear <= 2100 && secondYear == firstYear + 1;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    private boolean isValidSemester(String semester) {
        if (semester == null || semester.trim().isEmpty()) {
            return false;
        }
        return semester.equals("FIRST") || semester.equals("SECOND") || semester.equals("SUMMER");
    }

    @PostMapping("/verify-student")
    @ResponseBody
    public Map<String, Object> verifyStudent(@RequestParam String studentId) {
        Map<String, Object> response = new HashMap<>();
        try {
            Student student = studentRepository.findByStudentId(studentId)
                .orElseThrow(() -> new EntityNotFoundException("Student not found"));
            
            response.put("success", true);
            response.put("studentId", student.getStudentId());
            response.put("fullName", student.getFullName());
            response.put("program", student.getProgram());
            response.put("yearLevel", student.getYearLevel());
            response.put("semester", student.getSemester());
            response.put("academicYear", student.getAcademicYear());
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("error", "Invalid Student ID");
        }
        return response;
    }

    @PostMapping("/payment/library/process")
    public String processLibraryPayment(
            @RequestParam String studentId,
            @RequestParam String feeType,
            @RequestParam(required = false) String description,
            @RequestParam(defaultValue = "500.00") String amount,
            Model model) {
        try {
            // Input validation
            if (studentId == null || studentId.trim().isEmpty()) {
                model.addAttribute("error", "Student ID is required");
                return "features/library-payment";
            }

            if (feeType == null || feeType.trim().isEmpty()) {
                model.addAttribute("error", "Fee Type is required");
                return "features/library-payment";
            }

            // Amount validation
            BigDecimal paymentAmount;
            try {
                paymentAmount = new BigDecimal(amount);
            if (paymentAmount.compareTo(BigDecimal.ZERO) <= 0) {
                    model.addAttribute("error", "Payment amount must be greater than 0");
                    return "features/library-payment";
                }
            } catch (NumberFormatException e) {
                model.addAttribute("error", "Invalid amount format");
                return "features/library-payment";
            }

            // Student validation
            Student student;
            try {
                student = studentRepository.findByStudentId(studentId)
                    .orElseThrow(() -> new EntityNotFoundException("Student ID not found. Please register first."));
            } catch (EntityNotFoundException e) {
                model.addAttribute("error", e.getMessage());
                return "features/library-payment";
            }

            try {
                String notes = String.format("Fee Type: %s%s", 
                    feeType,
                    (description != null && !description.trim().isEmpty()) ? 
                        "\nDescription: " + description.trim() : "");

                // Create temporary payment object (not saved to database)
                Payment payment = Payment.builder()
                    .description("Library Fee Payment - " + feeType)
                    .amount(paymentAmount)
                    .type(PaymentType.CASH)
                    .user(student.getUser())
                    .paymentMethod("KIOSK")
                    .transactionReference("LIB-" + System.currentTimeMillis())
                    .notes(notes)
                    .build();
                
                model.addAttribute("payment", payment);
                model.addAttribute("student", student);
                
                return "features/payment-confirmation";
            } catch (Exception e) {
                logger.error("Error preparing payment: {}", e.getMessage());
                model.addAttribute("error", "Error preparing payment. Please try again.");
                return "features/library-payment";
            }
        } catch (Exception e) {
            logger.error("Unexpected error in library payment: {}", e.getMessage());
            model.addAttribute("error", "An unexpected error occurred. Please try again later.");
            model.addAttribute("studentId", studentId);
            model.addAttribute("feeType", feeType);
            model.addAttribute("description", description);
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

            // Create temporary payment object (not saved to database)
            Payment payment = Payment.builder()
                .description("Laboratory Fee Payment - " + labType)
                .amount(paymentAmount)
                .type(PaymentType.CASH)
                .user(student.getUser())
                .paymentMethod("KIOSK")
                .transactionReference("LAB-" + System.currentTimeMillis())
                .build();
            
            model.addAttribute("payment", payment);
            model.addAttribute("student", student);
            
            return "features/payment-confirmation";
        } catch (Exception e) {
            model.addAttribute("error", "Error preparing payment: " + e.getMessage());
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

            // Create temporary payment object (not saved to database)
            Payment payment = Payment.builder()
                .description("ID Replacement - " + reason)
                .amount(paymentAmount)
                .type(PaymentType.CASH)
                .user(student.getUser())
                .paymentMethod("KIOSK")
                .transactionReference("ID-" + System.currentTimeMillis())
                .build();
            
            model.addAttribute("payment", payment);
            model.addAttribute("student", student);
            
            return "features/payment-confirmation";
        } catch (Exception e) {
            model.addAttribute("error", "Error preparing payment: " + e.getMessage());
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

            // Create temporary payment object (not saved to database)
            Payment payment = Payment.builder()
                .description("Graduation Fee - " + graduationType)
                .amount(paymentAmount)
                .type(PaymentType.CASH)
                .user(student.getUser())
                .paymentMethod("KIOSK")
                .transactionReference("GRAD-" + System.currentTimeMillis())
                .build();
            
            model.addAttribute("payment", payment);
            model.addAttribute("student", student);
            
            return "features/payment-confirmation";
        } catch (Exception e) {
            model.addAttribute("error", "Error preparing payment: " + e.getMessage());
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
            @RequestParam Integer copies,
            @RequestParam String purpose,
            @RequestParam String deliveryMethod,
            @RequestParam(defaultValue = "200.00") String amount,
            Model model) {
        try {
            // Input validation
            if (studentId == null || studentId.trim().isEmpty()) {
                model.addAttribute("error", "Student ID is required");
                return "features/transcript-payment";
            }

            if (copies == null || copies < 1 || copies > 10) {
                model.addAttribute("error", "Number of copies must be between 1 and 10");
                return "features/transcript-payment";
            }

            if (purpose == null || purpose.trim().isEmpty()) {
                model.addAttribute("error", "Purpose is required");
                return "features/transcript-payment";
            }

            // Amount validation
            BigDecimal paymentAmount;
            try {
                paymentAmount = new BigDecimal(amount);
                if (paymentAmount.compareTo(BigDecimal.ZERO) <= 0) {
                    model.addAttribute("error", "Payment amount must be greater than 0");
                    return "features/transcript-payment";
                }
            } catch (NumberFormatException e) {
                model.addAttribute("error", "Invalid amount format");
                return "features/transcript-payment";
            }

            // Student validation
            Student student;
            try {
                student = studentRepository.findByStudentId(studentId)
                    .orElseThrow(() -> new EntityNotFoundException("Student ID not found. Please register first."));
            } catch (EntityNotFoundException e) {
                model.addAttribute("error", e.getMessage());
                return "features/transcript-payment";
            }

            try {
                // Calculate fees
                BigDecimal basePrice = new BigDecimal("200.00");

                // Create temporary payment object (not saved to database)
                Payment payment = Payment.builder()
                    .description("Transcript Request - " + copies + " copies (" + purpose + ")")
                    .amount(paymentAmount)
                    .type(PaymentType.CASH)
                    .user(student.getUser())
                    .paymentMethod("KIOSK")
                    .transactionReference("TOR-" + System.currentTimeMillis())
                    .notes("Transcript request details")
                    .copies(copies)
                    .purpose(purpose)
                    .basePrice(basePrice)
                    .build();
                
                model.addAttribute("payment", payment);
                model.addAttribute("student", student);
                
                return "features/payment-confirmation";
            } catch (Exception e) {
                logger.error("Error preparing payment: {}", e.getMessage());
                model.addAttribute("error", "Error preparing payment. Please try again.");
                return "features/transcript-payment";
            }
        } catch (Exception e) {
            logger.error("Unexpected error in transcript payment: {}", e.getMessage());
            model.addAttribute("error", "An unexpected error occurred. Please try again later.");
            model.addAttribute("studentId", studentId);
            model.addAttribute("copies", copies);
            model.addAttribute("purpose", purpose);
            model.addAttribute("amount", amount);
            return "features/transcript-payment";
        }
    }

    @PostMapping("/payment/confirm/{id}")
    @ResponseBody
    public Map<String, Object> confirmPayment(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        try {
            Payment payment = paymentService.getPaymentById(id);
            
            // If payment doesn't exist in database yet, save it as PENDING
            if (payment == null) {
                payment.setPaymentStatus(PaymentStatus.PENDING);
                payment = paymentService.createPayment(payment);
                
                response.put("success", true);
                response.put("message", "Payment saved successfully");
                return response;
            }
            
            // If payment exists and is PENDING, process it
            if (payment.getPaymentStatus() == PaymentStatus.PENDING) {
                // Process the payment
                Payment processedPayment = paymentService.processPayment(payment);
                if (processedPayment == null) {
                    throw new RuntimeException("Failed to process payment");
                }

                // Generate queue number
                String queueNumber = queueService.generateQueueNumber();
                if (queueNumber == null || queueNumber.trim().isEmpty()) {
                    throw new RuntimeException("Failed to generate queue number");
                }

                try {
                    queueService.createQueueEntry(queueNumber, processedPayment.getId());
                } catch (Exception e) {
                    logger.error("Failed to create queue entry: {}", e.getMessage());
                }

                processedPayment.setPaymentStatus(PaymentStatus.PROCESSED);
                processedPayment.setProcessedAt(LocalDateTime.now());
                paymentService.updatePayment(processedPayment);
                
                response.put("success", true);
                response.put("message", "Payment confirmed successfully");
                response.put("queueNumber", queueNumber);
            } else {
                response.put("success", false);
                response.put("error", "Only pending payments can be confirmed");
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

            // Create temporary payment object (not saved to database)
            Payment payment = Payment.builder()
                .description("New Student Enrollment - " + program + " (" + academicYear + " " + semester + ")")
                .amount(new BigDecimal(amount))
                .type(PaymentType.CASH)
                .paymentMethod("KIOSK")
                .transactionReference(enrollmentRef)
                .metadata(Map.of(
                    "applicantId", applicantId,
                    "fullName", fullName,
                    "email", email,
                    "contactNumber", contactNumber,
                    "program", program,
                    "academicYear", academicYear,
                    "semester", semester,
                    "paymentStatus", "ENROLLMENT_PAID"
                ))
                .build();
            
            model.addAttribute("payment", payment);
            model.addAttribute("enrollmentRef", enrollmentRef);
            
            return "features/payment-confirmation";
        } catch (Exception e) {
            model.addAttribute("error", "Error preparing payment: " + e.getMessage());
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

    @ExceptionHandler(Exception.class)
    public String handleError(Exception e, Model model) {
        logger.error("Global error in KioskController: {}", e.getMessage());
        model.addAttribute("error", "An unexpected error occurred. Please try again later.");
        return "features/error";
    }

    @ExceptionHandler(EntityNotFoundException.class)
    public String handleEntityNotFound(EntityNotFoundException e, Model model) {
        logger.error("Entity not found: {}", e.getMessage());
        model.addAttribute("error", e.getMessage());
        return "features/error";
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public String handleIllegalArgument(IllegalArgumentException e, Model model) {
        logger.error("Invalid argument: {}", e.getMessage());
        model.addAttribute("error", e.getMessage());
        return "features/error";
    }
} 