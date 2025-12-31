package com.javaapi.app.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
public class RootController {
    
    @Value("${app.service.name:java-api}")
    private String serviceName;
    
    @Value("${app.version:1.0.0}")
    private String version;
    
    @GetMapping("/")
    public ResponseEntity<Map<String, String>> root() {
        Map<String, String> response = new HashMap<>();
        response.put("service", serviceName);
        response.put("version", version);
        response.put("message", "Java API for observability POC - Spring Boot with structured logging and Prometheus metrics");
        return ResponseEntity.ok(response);
    }
}

