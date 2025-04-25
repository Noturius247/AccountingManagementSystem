package com.accounting.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.accounting.service.KioskService;
import com.accounting.service.QueueService;
import com.accounting.service.PdfService;
import com.accounting.model.Queue;
import com.accounting.model.QueuePosition;
import com.accounting.model.Payment;
import com.accounting.model.Student;
import com.accounting.model.enums.QueueStatus;
import com.accounting.model.enums.QueueType;
import com.accounting.model.User;
import com.accounting.repository.QueueRepository;
import com.accounting.repository.StudentRepository;
import com.accounting.repository.UserRepository;
import com.accounting.service.*;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.math.BigDecimal;
import com.accounting.model.enums.PaymentStatus;
import com.accounting.model.enums.PaymentType;
import com.accounting.service.PaymentService;
import com.accounting.repository.UserRepository;
import com.accounting.repository.StudentRepository;
import com.accounting.model.enums.ReceiptPreference;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import com.accounting.exception.ErrorResponse;
import java.time.LocalDateTime;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ContentDisposition;
import java.time.format.DateTimeFormatter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.accounting.service.StudentService;
import java.util.List;

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

    @Autowired
    private StudentService studentService;

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
            case "chemistry":
                return "features/chemistry-payment";
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
        // Get the first queue by position and creation time
        List<Queue> queues = queueRepository.findByStatusOrderByPositionAscCreatedAtAsc(QueueStatus.PROCESSING);
        if (queues.isEmpty()) {
            queues = queueRepository.findByStatusOrderByPositionAscCreatedAtAsc(QueueStatus.PENDING);
        }
        
        Queue currentQueue = queues.isEmpty() ? null : queues.get(0);
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
        return "kiosk/kiosk-payment";
    }

    @GetMapping("/search")
    public String searchPayments(@RequestParam String query, Model model) {
        model.addAttribute("searchResults", kioskService.searchPaymentItems(query));
        return "kiosk/kiosk-search";
    }

    @GetMapping("/transactions")
    public String viewTransactions(Model model) {
        // Add transaction data to model
        return "kiosk/kiosk-transactions";
    }

    @GetMapping("/payments")
    public String viewPayments(Model model) {
        // Add payment data to model
        return "kiosk/kiosk-payments";
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
            List<Queue> queues = queueRepository.findByStatusOrderByPositionAscCreatedAtAsc(QueueStatus.PROCESSING);
            if (queues.isEmpty()) {
                queues = queueRepository.findByStatusOrderByPositionAscCreatedAtAsc(QueueStatus.PENDING);
            }
            
            Queue currentQueue = queues.isEmpty() ? null : queues.get(0);
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
        return "kiosk/payment-confirmation";
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
        return semester.equals("FIRST") || semester.equals("SECOND") || semester.equals("SUMMER") ||
               semester.equals("1ST") || semester.equals("2ND") || semester.equals("SUM");
    }

    private String convertSemesterFormat(String semester) {
        switch(semester.toUpperCase()) {
            case "FIRST":
            case "1ST":
                return "1ST";
            case "SECOND":
            case "2ND":
                return "2ND";
            case "SUMMER":
            case "SUM":
                return "SUM";
            default:
                return semester;
        }
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

                // Convert semester format before comparison
                String normalizedInputSemester = convertSemesterFormat(semester);
                String normalizedStudentSemester = convertSemesterFormat(student.getSemester());

                // Validate if semester matches student's current semester
                if (!normalizedInputSemester.equals(normalizedStudentSemester)) {
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
                // Create and save payment object
                Payment payment = new Payment();
                payment.setDescription("Tuition Payment - " + academicYear + " Semester " + convertSemesterFormat(semester));
                payment.setAmount(paymentAmount);
                payment.setType("TUITION");
                payment.setUser(student.getUser());
                payment.setPaymentMethod("KIOSK");
                payment.setNotes(notes != null ? notes.trim() : null);
                payment.setPaymentStatus(PaymentStatus.PENDING);
                payment.setCurrency("PHP");
                payment.setAcademicYear(academicYear);
                payment.setSemester(semester);

                // Save the payment only once through createPayment
                payment = paymentService.createPayment(payment);
                
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

    @GetMapping("/verify-student")
    @PostMapping("/verify-student")
    public ResponseEntity<?> verifyStudent(@RequestParam String studentId) {
        try {
            Student student = studentService.getStudentByStudentId(studentId);
            
            if (student.getRegistrationStatus() != Student.RegistrationStatus.APPROVED) {
                return ResponseEntity.badRequest()
                    .body(Map.of("error", "Student registration is not yet approved"));
            }

            // Convert semester to form format
            String formattedSemester;
            switch(student.getSemester()) {
                case "1ST":
                    formattedSemester = "FIRST";
                    break;
                case "2ND":
                    formattedSemester = "SECOND";
                    break;
                case "SUM":
                    formattedSemester = "SUMMER";
                    break;
                default:
                    formattedSemester = student.getSemester();
            }

            Map<String, Object> response = new HashMap<>();
            response.put("fullName", student.getFullName());
            response.put("program", student.getProgram());
            response.put("yearLevel", student.getYearLevel());
            response.put("section", student.getSection());
            response.put("academicYear", student.getAcademicYear());
            response.put("semester", formattedSemester);

            return ResponseEntity.ok(response);
        } catch (EntityNotFoundException e) {
            return ResponseEntity.badRequest()
                .body(Map.of("error", "Student ID not found"));
        } catch (Exception e) {
            logger.error("Error verifying student: ", e);
            return ResponseEntity.badRequest()
                .body(Map.of("error", "Error verifying student"));
        }
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

                // Create and save payment object
                Payment payment = Payment.builder()
                    .description("Library Fee Payment - " + feeType)
                    .amount(paymentAmount)
                    .type("LIBRARY")
                    .user(student.getUser())
                    .paymentMethod("KIOSK")
                    .notes(notes)
                    .build();

                // Save the payment
                payment = paymentService.createPayment(payment);
                
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
            @RequestParam String academicYear,
            @RequestParam String semester,
            Model model) {
        try {
            // Input validation
            if (studentId == null || studentId.trim().isEmpty()) {
                model.addAttribute("error", "Student ID is required");
                return "features/lab-payment";
            }

            // Academic Year validation
            if (!isValidAcademicYear(academicYear)) {
                model.addAttribute("error", "Invalid Academic Year format. Expected format: YYYY-YYYY");
                return "features/lab-payment";
            }

            // Semester validation
            if (!isValidSemester(semester)) {
                model.addAttribute("error", "Invalid Semester. Must be FIRST, SECOND, or SUMMER");
                return "features/lab-payment";
            }

            Student student = studentRepository.findByStudentId(studentId)
                .orElseThrow(() -> new EntityNotFoundException("Student ID not found. Please register first."));

            BigDecimal paymentAmount = new BigDecimal(amount);
            if (paymentAmount.compareTo(BigDecimal.ZERO) <= 0) {
                throw new IllegalArgumentException("Payment amount must be greater than 0");
            }

            // Create and save payment object
            Payment payment = Payment.builder()
                .description("Laboratory Fee Payment - " + labType + " (" + academicYear + " " + semester + ")")
                .amount(paymentAmount)
                .type("LAB")
                .user(student.getUser())
                .paymentMethod("KIOSK")
                .academicYear(academicYear)
                .semester(semester)
                .build();

            // Save the payment
            payment = paymentService.createPayment(payment);
            
            model.addAttribute("payment", payment);
            model.addAttribute("student", student);
            
            return "features/payment-confirmation";
        } catch (Exception e) {
            model.addAttribute("error", "Error preparing payment: " + e.getMessage());
            model.addAttribute("studentId", studentId);
            model.addAttribute("studentName", studentName);
            model.addAttribute("labType", labType);
            model.addAttribute("amount", amount);
            model.addAttribute("academicYear", academicYear);
            model.addAttribute("semester", semester);
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

            // Create and save payment object
            Payment payment = Payment.builder()
                .description("ID Replacement - " + reason)
                .amount(paymentAmount)
                .type("ID")
                .user(student.getUser())
                .paymentMethod("KIOSK")
                .build();

            // Save the payment
            payment = paymentService.createPayment(payment);
            
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

            // Create and save payment object
            Payment payment = Payment.builder()
                .description("Graduation Fee - " + graduationType)
                .amount(paymentAmount)
                .type("GRADUATION")
                .user(student.getUser())
                .paymentMethod("KIOSK")
                .build();

            // Save the payment
            payment = paymentService.createPayment(payment);
            
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

                // Create and save payment object
                Payment payment = Payment.builder()
                    .description("Transcript Request - " + copies + " copies (" + purpose + ")")
                    .amount(paymentAmount)
                    .type("TRANSCRIPT")
                    .user(student.getUser())
                    .paymentMethod("KIOSK")
                    .notes("Transcript request details")
                    .copies(copies)
                    .purpose(purpose)
                    .basePrice(basePrice)
                    .build();

                // Save the payment
                payment = paymentService.createPayment(payment);
                
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

            // Create and save payment object
            Payment payment = Payment.builder()
                .description("New Student Enrollment - " + program + " (" + academicYear + " " + semester + ")")
                .amount(new BigDecimal(amount))
                .type("ENROLLMENT")
                .paymentMethod("KIOSK")
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

            // Save the payment
            payment = paymentService.createPayment(payment);
            
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

    @PostMapping("/payment/chemistry/process")
    public String processChemistryPayment(
            @RequestParam String studentId,
            @RequestParam String labType,
            @RequestParam String academicYear,
            @RequestParam String semester,
            @RequestParam String section,
            @RequestParam String equipment,
            @RequestParam String amount,
            Model model) {
        try {
            // Input validation
            if (studentId == null || studentId.trim().isEmpty()) {
                model.addAttribute("error", "Student ID is required");
                return "features/chemistry-payment";
            }

            // Academic Year validation
            if (!isValidAcademicYear(academicYear)) {
                model.addAttribute("error", "Invalid Academic Year format. Expected format: YYYY-YYYY");
                return "features/chemistry-payment";
            }

            // Semester validation
            if (!isValidSemester(semester)) {
                model.addAttribute("error", "Invalid Semester. Must be FIRST, SECOND, or SUMMER");
                return "features/chemistry-payment";
            }

            // Amount validation
            BigDecimal paymentAmount;
            try {
                paymentAmount = new BigDecimal(amount);
                if (paymentAmount.compareTo(BigDecimal.ZERO) <= 0) {
                    model.addAttribute("error", "Payment amount must be greater than 0");
                    return "features/chemistry-payment";
                }
            } catch (NumberFormatException e) {
                model.addAttribute("error", "Invalid amount format");
                return "features/chemistry-payment";
            }

            // Student validation
            Student student;
            try {
                student = studentRepository.findByStudentId(studentId)
                    .orElseThrow(() -> new EntityNotFoundException("Student ID not found. Please register first."));
            } catch (EntityNotFoundException e) {
                model.addAttribute("error", e.getMessage());
                return "features/chemistry-payment";
            }

            try {
                String notes = String.format("Lab Type: %s\nSection: %s\nEquipment: %s", 
                    labType, section, equipment);

                // Create and save payment object
                Payment payment = Payment.builder()
                    .description("Chemistry Laboratory Fee - " + labType)
                    .amount(paymentAmount)
                    .type("CHEMISTRY")
                    .user(student.getUser())
                    .paymentMethod("KIOSK")
                    .notes(notes)
                    .build();

                // Save the payment
                payment = paymentService.createPayment(payment);
                
                model.addAttribute("payment", payment);
                model.addAttribute("student", student);
                
                return "features/payment-confirmation";
            } catch (Exception e) {
                logger.error("Error preparing payment: {}", e.getMessage());
                model.addAttribute("error", "Error preparing payment. Please try again.");
                return "features/chemistry-payment";
            }
        } catch (Exception e) {
            logger.error("Unexpected error in chemistry payment: {}", e.getMessage());
            model.addAttribute("error", "An unexpected error occurred. Please try again later.");
            // Preserve form data
            model.addAttribute("studentId", studentId);
            model.addAttribute("labType", labType);
            model.addAttribute("academicYear", academicYear);
            model.addAttribute("semester", semester);
            model.addAttribute("section", section);
            model.addAttribute("equipment", equipment);
            model.addAttribute("amount", amount);
            return "features/chemistry-payment";
        }
    }

    @PostMapping("/payment/confirm/{transactionRef}")
    @ResponseBody
    public Map<String, Object> confirmPayment(@PathVariable String transactionRef) {
        Map<String, Object> response = new HashMap<>();
        try {
            // Get the payment by transaction reference (read only)
            Payment payment = paymentService.getPaymentByTransactionReference(transactionRef);
            
            // Create queue entry and get position
            QueuePosition queuePosition = queueService.createQueueEntry(payment.getUser().getUsername(), payment.getId());

            // Add queue information to response
            response.put("success", true);
            response.put("queueNumber", payment.getPaymentNumber());
            response.put("position", queuePosition.getPosition());
            response.put("estimatedWaitTime", queuePosition.getEstimatedWaitTime());
            response.put("message", "Payment confirmed and pending manager approval");

            // Set receipt preference but don't generate it yet (will be generated after manager approval)
            queueService.setReceiptPreference(payment.getPaymentNumber(), ReceiptPreference.DIGITAL);

        } catch (Exception e) {
            logger.error("Error confirming payment: {}", e.getMessage());
            response.put("success", false);
            response.put("message", "Payment confirmation in progress");
        }
        return response;
    }

    @PostMapping("/payment/cancel/{transactionRef}")
    @ResponseBody
    public Map<String, Object> cancelPayment(@PathVariable String transactionRef) {
        Map<String, Object> response = new HashMap<>();
        try {
            // Get the payment by transaction reference
            Payment payment = paymentService.getPaymentByTransactionReference(transactionRef);
            if (payment == null) {
                throw new EntityNotFoundException("Payment not found");
            }

            // Set payment status to FAILED
            payment.setPaymentStatus(PaymentStatus.FAILED);
            paymentService.updatePayment(payment);

            response.put("success", true);
            response.put("message", "Payment cancelled successfully");
        } catch (Exception e) {
            logger.error("Error cancelling payment: {}", e.getMessage());
            response.put("success", false);
            response.put("error", "Failed to cancel payment: " + e.getMessage());
        }
        return response;
    }

    @GetMapping("/queue/status/{queueNumber}")
    @ResponseBody
    public Map<String, Object> getQueueStatus(@PathVariable String queueNumber) {
        Map<String, Object> response = new HashMap<>();
        try {
            Map<String, Object> queueInfo = queueService.getQueueInfo(queueNumber);
            response.put("success", true);
            response.put("queueInfo", queueInfo);
        } catch (Exception e) {
            logger.error("Error getting queue status: {}", e.getMessage());
            response.put("success", false);
            response.put("error", "Failed to get queue status: " + e.getMessage());
        }
        return response;
    }

    @ExceptionHandler(Exception.class)
    public String handleError(Exception e, Model model) {
        logger.error("Global error in KioskController: {}", e.getMessage());
        model.addAttribute("error", "An unexpected error occurred. Please try again later.");
        return "kiosk/error";
    }

    @ExceptionHandler(EntityNotFoundException.class)
    public String handleEntityNotFound(EntityNotFoundException e, Model model) {
        logger.error("Entity not found: {}", e.getMessage());
        model.addAttribute("error", e.getMessage());
        return "kiosk/error";
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public String handleIllegalArgument(IllegalArgumentException e, Model model) {
        logger.error("Invalid argument: {}", e.getMessage());
        model.addAttribute("error", e.getMessage());
        return "kiosk/error";
    }
} 