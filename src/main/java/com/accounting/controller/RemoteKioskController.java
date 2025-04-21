package com.accounting.controller;

import com.accounting.model.QueuePosition;
import com.accounting.service.QueueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Map;
import java.util.HashMap;

@RestController
@RequestMapping("/api/remote-kiosk")
@CrossOrigin(origins = "*") // Enable CORS for remote access
public class RemoteKioskController {

    @Autowired
    private QueueService queueService;

    @PostMapping("/queue")
    public ResponseEntity<Map<String, Object>> createQueue(
            @RequestParam String publicIdentifier,
            @RequestParam(required = false) String deviceId,
            @RequestParam(required = false) String deviceType) {
        
        try {
            // Create queue with device information as terminal ID
            String kioskTerminalId = generateDeviceIdentifier(deviceId, deviceType);
            QueuePosition queue = queueService.createPublicQueue(publicIdentifier, kioskTerminalId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("queueNumber", queue.getQueueNumber());
            response.put("position", queue.getPosition());
            response.put("estimatedWaitTime", queue.getEstimatedWaitTime());
            response.put("kioskSessionId", queue.getKioskSessionId());
            response.put("deviceId", deviceId);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }

    @GetMapping("/queue/status")
    public ResponseEntity<Map<String, Object>> getQueueStatus(
            @RequestParam String publicIdentifier,
            @RequestParam String kioskSessionId) {
        
        try {
            QueuePosition status = queueService.getPublicQueueStatus(publicIdentifier, kioskSessionId);
            if (status == null) {
                return ResponseEntity.notFound().build();
            }
            
            Map<String, Object> response = new HashMap<>();
            response.put("position", status.getPosition());
            response.put("estimatedWaitTime", status.getEstimatedWaitTime());
            response.put("status", "ACTIVE");
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }

    @DeleteMapping("/queue/cancel")
    public ResponseEntity<Map<String, Object>> cancelQueue(
            @RequestParam String publicIdentifier,
            @RequestParam String kioskSessionId) {
        
        try {
            queueService.cancelPublicQueue(publicIdentifier, kioskSessionId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Queue cancelled successfully");
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }

    @GetMapping("/queue/validate")
    public ResponseEntity<Map<String, Object>> validateQueue(
            @RequestParam String publicIdentifier,
            @RequestParam String kioskSessionId) {
        
        try {
            boolean isValid = queueService.isValidPublicQueue(publicIdentifier, kioskSessionId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("valid", isValid);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }

    private String generateDeviceIdentifier(String deviceId, String deviceType) {
        String baseId = deviceId != null ? deviceId : "REMOTE";
        String type = deviceType != null ? deviceType : "UNKNOWN";
        return String.format("RMT-%s-%s", type, baseId);
    }
} 