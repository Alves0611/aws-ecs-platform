package com.javaapi.app.model;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;

public class WorkRequest {
    @Min(0)
    @Max(10000)
    private int sleepMs = 100;
    
    private boolean fail = false;

    public int getSleepMs() {
        return sleepMs;
    }

    public void setSleepMs(int sleepMs) {
        this.sleepMs = sleepMs;
    }

    public boolean isFail() {
        return fail;
    }

    public void setFail(boolean fail) {
        this.fail = fail;
    }
}

