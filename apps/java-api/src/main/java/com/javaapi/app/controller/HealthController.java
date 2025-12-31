package com.javaapi.app.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
public class HealthController {
    
    @Value("${app.service.name:java-api}")
    private String serviceName;
    
    @GetMapping("/healthz")
    public ResponseEntity<Map<String, Object>> healthz() {
        Map<String, Object> response = new HashMap<>();
        response.put("ok", true);
        response.put("service", serviceName);
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/readyz")
    public ResponseEntity<Map<String, Object>> readyz() {
        Map<String, Object> response = new HashMap<>();
        response.put("ready", true);
        response.put("service", serviceName);
        return ResponseEntity.ok(response);
    }
}

