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

@Controller
@RequestMapping("/kiosk")
public class KioskController {

    @Autowired
    private KioskService kioskService;

    @Autowired
    private QueueService queueService;

    @Autowired
    private QueueRepository queueRepository;

    @GetMapping("")
    public String kioskHome(Model model) {
        model.addAttribute("paymentItems", kioskService.getAllPaymentItems());
        model.addAttribute("categories", kioskService.getAllCategories());
        return "features/kiosk";
    }

    @GetMapping("/queue/new")
    public String generateQueueNumber(@RequestParam Long paymentItemId) {
        String queueNumber = queueService.generateQueueNumber();
        queueService.createQueueEntry(queueNumber, paymentItemId);
        return "redirect:/kiosk/queue/status?number=" + queueNumber;
    }

    @GetMapping("/queue/status")
    public String queueStatus(@RequestParam String number, Model model) {
        model.addAttribute("queueInfo", queueService.getQueueInfo(number));
        model.addAttribute("estimatedWaitTime", queueService.getEstimatedWaitTime(number));
        return "features/kiosk-status";
    }

    @GetMapping("/payment/{id}")
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

    @GetMapping("/queue")
    public String viewQueue(Model model) {
        // Add queue data to model
        return "features/kiosk-queue";
    }

    @GetMapping("/queue-status")
    @ResponseBody
    public Map<String, Object> getQueueStatus(@RequestParam String number) {
        Map<String, Object> response = new HashMap<>();
        try {
            Optional<Queue> queueOpt = queueService.findByQueueNumber(number);
            if (queueOpt.isPresent()) {
                Queue queue = queueOpt.get();
                response.put("status", queue.getStatus().name());
                response.put("position", queueService.getQueuePosition(number));
                response.put("estimatedWaitTime", queueService.calculateEstimatedWaitTime(number));
            } else {
                response.put("error", "Queue not found");
            }
        } catch (Exception e) {
            response.put("error", e.getMessage());
        }
        return response;
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
} 