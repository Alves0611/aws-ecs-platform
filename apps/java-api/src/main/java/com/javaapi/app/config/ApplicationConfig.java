package com.javaapi.app.config;

import org.springframework.context.annotation.Configuration;

@Configuration
public class ApplicationConfig {
    // Configuration properties are injected via @Value in controllers
    // No need for beans here since we use @Value directly
}

