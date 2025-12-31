package com.javaapi.app.filter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.web.util.ContentCachingRequestWrapper;
import org.springframework.web.util.ContentCachingResponseWrapper;

import java.io.IOException;
import java.util.UUID;

@Component
public class RequestLoggingFilter extends OncePerRequestFilter {
    
    private static final Logger logger = LoggerFactory.getLogger(RequestLoggingFilter.class);
    
    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain) throws ServletException, IOException {
        
        String requestId = getOrCreateRequestId(request);
        MDC.put("request_id", requestId);
        
        long startTime = System.currentTimeMillis();
        
        // Wrap request/response to enable reading body multiple times
        ContentCachingRequestWrapper wrappedRequest = new ContentCachingRequestWrapper(request);
        ContentCachingResponseWrapper wrappedResponse = new ContentCachingResponseWrapper(response);
        
        wrappedResponse.setHeader("X-Request-Id", requestId);
        
        try {
            logger.info("Request started", java.util.Map.of(
                "method", request.getMethod(),
                "path", request.getRequestURI(),
                "query", request.getQueryString() != null ? request.getQueryString() : "",
                "client", request.getRemoteAddr()
            ));
            
            filterChain.doFilter(wrappedRequest, wrappedResponse);
            
            long durationMs = System.currentTimeMillis() - startTime;
            
            logger.info("Request completed", java.util.Map.of(
                "method", request.getMethod(),
                "path", request.getRequestURI(),
                "status", String.valueOf(wrappedResponse.getStatus()),
                "duration_ms", String.valueOf(durationMs)
            ));
            
        } catch (Exception e) {
            logger.error("Request failed with exception", java.util.Map.of(
                "method", request.getMethod(),
                "path", request.getRequestURI(),
                "error", e.getMessage(),
                "error_type", e.getClass().getSimpleName()
            ));
            throw e;
        } finally {
            wrappedResponse.copyBodyToResponse();
            MDC.clear();
        }
    }
    
    private String getOrCreateRequestId(HttpServletRequest request) {
        String requestId = request.getHeader("X-Request-Id");
        if (requestId == null || requestId.isEmpty()) {
            requestId = UUID.randomUUID().toString();
        }
        return requestId;
    }
}

