package com.accounting.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.accounting.service.KioskService;
import com.accounting.service.QueueService;

@Controller
@RequestMapping("/kiosk")
public class KioskController {

    @Autowired
    private KioskService kioskService;

    @Autowired
    private QueueService queueService;

    @GetMapping("")
    public String kioskHome(Model model) {
        model.addAttribute("paymentItems", kioskService.getAllPaymentItems());
        model.addAttribute("categories", kioskService.getAllCategories());
        return "kiosk/home";
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
        return "kiosk/queue-status";
    }

    @GetMapping("/payment/{id}")
    public String paymentDetails(@PathVariable Long id, Model model) {
        model.addAttribute("paymentItem", kioskService.getPaymentItem(id));
        return "kiosk/payment-details";
    }

    @GetMapping("/search")
    public String searchPayments(@RequestParam String query, Model model) {
        model.addAttribute("searchResults", kioskService.searchPaymentItems(query));
        return "kiosk/search-results";
    }
} 