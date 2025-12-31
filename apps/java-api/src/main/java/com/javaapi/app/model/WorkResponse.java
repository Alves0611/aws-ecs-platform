package com.javaapi.app.model;

public class WorkResponse {
    private String status;
    private double durationMs;
    private String message;

    public WorkResponse() {
    }

    public WorkResponse(String status, double durationMs, String message) {
        this.status = status;
        this.durationMs = durationMs;
        this.message = message;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public double getDurationMs() {
        return durationMs;
    }

    public void setDurationMs(double durationMs) {
        this.durationMs = durationMs;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}

