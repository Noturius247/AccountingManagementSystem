package com.accounting.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.accounting.service.KioskService;
import com.accounting.service.QueueService;
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

@Controller
@RequestMapping("/kiosk")
public class KioskController {

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

    @GetMapping("")
    public String showKiosk() {
        return "features/kiosk";
    }

    @GetMapping("/payment/{type}")
    public String showPaymentForm(@PathVariable String type) {
        switch(type) {
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
    public String showQueue() {
        return "features/queue";
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

    @GetMapping("/queue-status")
    @ResponseBody
    public ResponseEntity<QueuePosition> getQueueStatus(Authentication authentication) {
        User user = userService.findByUsername(authentication.getName())
            .orElseThrow(() -> new RuntimeException("User not found"));
        QueuePosition status = queueService.getQueueStatus(user);
        return ResponseEntity.ok(status);
    }

    @PostMapping("/cancel-queue")
    @ResponseBody
    public Map<String, Object> cancelQueue(@RequestParam String number) {
        Map<String, Object> response = new HashMap<>();
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
} 