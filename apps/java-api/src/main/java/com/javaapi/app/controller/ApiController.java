package com.javaapi.app.controller;

import com.javaapi.app.model.WorkRequest;
import com.javaapi.app.model.WorkResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1")
public class ApiController {
    
    private static final Logger logger = LoggerFactory.getLogger(ApiController.class);
    
    @Value("${app.service.name:java-api}")
    private String serviceName;
    
    @GetMapping("/hello")
    public ResponseEntity<Map<String, String>> hello(
            @RequestParam(required = false, defaultValue = "World") String name,
            HttpServletRequest request) {
        String requestId = getOrCreateRequestId(request);
        
        logger.info("Greeting generated", Map.of(
            "name", name,
            "request_id", requestId
        ));
        
        String greeting = "Hello, " + name + "!";
        Map<String, String> response = new HashMap<>();
        response.put("greeting", greeting);
        response.put("service", serviceName);
        response.put("request_id", requestId);
        
        return ResponseEntity.ok()
            .header("X-Request-Id", requestId)
            .body(response);
    }
    
    @PostMapping("/work")
    public ResponseEntity<WorkResponse> work(
            @Valid @RequestBody WorkRequest workRequest,
            HttpServletRequest request) {
        String requestId = getOrCreateRequestId(request);
        
        logger.info("Work job started", Map.of(
            "sleep_ms", String.valueOf(workRequest.getSleepMs()),
            "fail", String.valueOf(workRequest.isFail()),
            "request_id", requestId
        ));
        
        long startTime = System.currentTimeMillis();
        
        try {
            // Simulate work
            Thread.sleep(workRequest.getSleepMs());
            
            // Simulate failure if requested
            if (workRequest.isFail()) {
                logger.error("Work job failed (simulated)", Map.of(
                    "sleep_ms", String.valueOf(workRequest.getSleepMs()),
                    "request_id", requestId
                ));
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .header("X-Request-Id", requestId)
                    .build();
            }
            
            long durationMs = System.currentTimeMillis() - startTime;
            
            logger.info("Work job completed successfully", Map.of(
                "sleep_ms", String.valueOf(workRequest.getSleepMs()),
                "actual_duration_ms", String.valueOf(durationMs),
                "request_id", requestId
            ));
            
            WorkResponse response = new WorkResponse(
                "success",
                durationMs,
                "Work completed after " + workRequest.getSleepMs() + "ms"
            );
            
            return ResponseEntity.ok()
                .header("X-Request-Id", requestId)
                .body(response);
            
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            logger.error("Work job interrupted", Map.of(
                "error", e.getMessage(),
                "request_id", requestId
            ));
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .header("X-Request-Id", requestId)
                .build();
        } catch (Exception e) {
            logger.error("Work job failed with exception", Map.of(
                "error", e.getMessage(),
                "error_type", e.getClass().getSimpleName(),
                "request_id", requestId
            ));
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .header("X-Request-Id", requestId)
                .build();
        }
    }
    
    private String getOrCreateRequestId(HttpServletRequest request) {
        String requestId = request.getHeader("X-Request-Id");
        if (requestId == null || requestId.isEmpty()) {
            requestId = UUID.randomUUID().toString();
        }
        MDC.put("request_id", requestId);
        return requestId;
    }
}

