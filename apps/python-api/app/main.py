"""
Python API - FastAPI with Production-like Observability
Features: Structured logging, Prometheus metrics, Health checks, Request tracing
"""
import asyncio
import logging
import time
import uuid
from typing import Optional

from fastapi import FastAPI, Request, Response, HTTPException
from fastapi.responses import JSONResponse, PlainTextResponse
from pydantic import BaseModel, Field
from pythonjsonlogger import jsonlogger
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST, CollectorRegistry

# ============================================================================
# Configuration
# ============================================================================
SERVICE_NAME = "python-api"
VERSION = "1.0.0"

# ============================================================================
# JSON Structured Logging Setup
# ============================================================================
class CustomJsonFormatter(jsonlogger.JsonFormatter):
    """Custom JSON formatter with standard fields"""
    def add_fields(self, log_record, record, message_dict):
        super().add_fields(log_record, record, message_dict)
        log_record['timestamp'] = self.formatTime(record, self.datefmt)
        log_record['level'] = record.levelname
        log_record['service'] = SERVICE_NAME
        if not log_record.get('name'):
            log_record['name'] = record.name

# Configure root logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Remove default handlers
for handler in logger.handlers[:]:
    logger.removeHandler(handler)

# Add JSON handler to stdout
logHandler = logging.StreamHandler()
formatter = CustomJsonFormatter(
    '%(timestamp)s %(level)s %(service)s %(name)s %(message)s',
    datefmt='%Y-%m-%dT%H:%M:%S'
)
logHandler.setFormatter(formatter)
logger.addHandler(logHandler)

app_logger = logging.getLogger(__name__)

# ============================================================================
# Prometheus Metrics
# ============================================================================
registry = CollectorRegistry()

http_requests_total = Counter(
    'http_requests_total',
    'Total HTTP requests',
    ['service', 'method', 'path', 'status'],
    registry=registry
)

http_request_duration_seconds = Histogram(
    'http_request_duration_seconds',
    'HTTP request duration in seconds',
    ['service', 'method', 'path'],
    registry=registry,
    buckets=(0.005, 0.01, 0.025, 0.05, 0.075, 0.1, 0.25, 0.5, 0.75, 1.0, 2.5, 5.0, 7.5, 10.0)
)

app_work_jobs_total = Counter(
    'app_work_jobs_total',
    'Total work jobs processed',
    ['service', 'result'],
    registry=registry
)

# ============================================================================
# FastAPI Application
# ============================================================================
app = FastAPI(
    title="Python API - Observability POC",
    description="FastAPI with structured logging and Prometheus metrics",
    version=VERSION
)

# ============================================================================
# Request Models
# ============================================================================
class WorkRequest(BaseModel):
    sleep_ms: int = Field(default=100, ge=0, le=10000, description="Sleep duration in milliseconds")
    fail: bool = Field(default=False, description="Simulate failure if True")

class WorkResponse(BaseModel):
    status: str
    duration_ms: float
    message: str

# ============================================================================
# Middleware - Request ID and Logging
# ============================================================================
@app.middleware("http")
async def request_middleware(request: Request, call_next):
    """
    Middleware to handle:
    - Request ID generation/extraction
    - Request/response logging
    - Metrics collection
    """
    # Generate or extract request_id
    request_id = request.headers.get("X-Request-Id", str(uuid.uuid4()))
    request.state.request_id = request_id
    
    # Start timer
    start_time = time.time()
    
    # Log request start
    app_logger.info(
        "Request started",
        extra={
            "request_id": request_id,
            "method": request.method,
            "path": request.url.path,
            "query": str(request.query_params) if request.query_params else None,
            "client": request.client.host if request.client else None
        }
    )
    
    # Process request
    try:
        response = await call_next(request)
        status_code = response.status_code
    except Exception as e:
        app_logger.error(
            "Request failed with exception",
            extra={
                "request_id": request_id,
                "method": request.method,
                "path": request.url.path,
                "error": str(e),
                "error_type": type(e).__name__
            },
            exc_info=True
        )
        status_code = 500
        response = JSONResponse(
            status_code=500,
            content={"error": "Internal server error", "request_id": request_id}
        )
    
    # Calculate duration
    duration_ms = (time.time() - start_time) * 1000
    duration_seconds = duration_ms / 1000
    
    # Record metrics
    http_requests_total.labels(
        service=SERVICE_NAME,
        method=request.method,
        path=request.url.path,
        status=status_code
    ).inc()
    
    http_request_duration_seconds.labels(
        service=SERVICE_NAME,
        method=request.method,
        path=request.url.path
    ).observe(duration_seconds)
    
    # Log request completion
    app_logger.info(
        "Request completed",
        extra={
            "request_id": request_id,
            "method": request.method,
            "path": request.url.path,
            "status": status_code,
            "duration_ms": round(duration_ms, 2)
        }
    )
    
    # Add request_id to response headers
    response.headers["X-Request-Id"] = request_id
    
    return response

# ============================================================================
# Routes
# ============================================================================

@app.get("/", tags=["Root"])
async def root():
    """Root endpoint - service information"""
    return {
        "service": SERVICE_NAME,
        "version": VERSION,
        "message": "Python API for observability POC - FastAPI with structured logging and Prometheus metrics"
    }

@app.get("/healthz", tags=["Health"])
async def healthz():
    """Liveness probe - is the service alive?"""
    return {"ok": True, "service": SERVICE_NAME}

@app.get("/readyz", tags=["Health"])
async def readyz():
    """Readiness probe - is the service ready to accept traffic?"""
    # In a real app, check database connections, dependencies, etc.
    return {"ready": True, "service": SERVICE_NAME}

@app.get("/metrics", tags=["Metrics"])
async def metrics():
    """Prometheus metrics endpoint"""
    return Response(
        content=generate_latest(registry),
        media_type=CONTENT_TYPE_LATEST
    )

@app.get("/api/v1/hello", tags=["API"])
async def hello(name: Optional[str] = "World", request: Request = None):
    """
    Simple greeting endpoint
    Demonstrates structured logging with request context
    """
    request_id = getattr(request.state, 'request_id', 'unknown')
    
    greeting = f"Hello, {name}!"
    
    app_logger.info(
        "Greeting generated",
        extra={
            "request_id": request_id,
            "name": name,
            "greeting": greeting
        }
    )
    
    return {
        "greeting": greeting,
        "service": SERVICE_NAME,
        "request_id": request_id
    }

@app.post("/api/v1/work", tags=["API"], response_model=WorkResponse)
async def work(work_request: WorkRequest, request: Request):
    """
    Simulates work/load for testing
    - Configurable sleep duration
    - Can simulate failures
    - Generates structured logs
    - Updates custom metrics
    """
    request_id = getattr(request.state, 'request_id', 'unknown')
    
    app_logger.info(
        "Work job started",
        extra={
            "request_id": request_id,
            "sleep_ms": work_request.sleep_ms,
            "fail": work_request.fail
        }
    )
    
    start_time = time.time()
    
    try:
        # Simulate work
        await asyncio.sleep(work_request.sleep_ms / 1000)
        
        # Simulate failure if requested
        if work_request.fail:
            app_work_jobs_total.labels(service=SERVICE_NAME, result="error").inc()
            app_logger.error(
                "Work job failed (simulated)",
                extra={
                    "request_id": request_id,
                    "sleep_ms": work_request.sleep_ms
                }
            )
            raise HTTPException(status_code=500, detail="Simulated failure")
        
        duration_ms = (time.time() - start_time) * 1000
        
        # Record success
        app_work_jobs_total.labels(service=SERVICE_NAME, result="ok").inc()
        
        app_logger.info(
            "Work job completed successfully",
            extra={
                "request_id": request_id,
                "sleep_ms": work_request.sleep_ms,
                "actual_duration_ms": round(duration_ms, 2)
            }
        )
        
        return WorkResponse(
            status="success",
            duration_ms=round(duration_ms, 2),
            message=f"Work completed after {work_request.sleep_ms}ms"
        )
        
    except HTTPException:
        raise
    except Exception as e:
        app_work_jobs_total.labels(service=SERVICE_NAME, result="error").inc()
        app_logger.error(
            "Work job failed with exception",
            extra={
                "request_id": request_id,
                "error": str(e),
                "error_type": type(e).__name__
            },
            exc_info=True
        )
        raise HTTPException(status_code=500, detail=str(e))

# ============================================================================
# Startup/Shutdown Events
# ============================================================================
@app.on_event("startup")
async def startup_event():
    """Log application startup"""
    app_logger.info(
        "Application starting",
        extra={
            "service": SERVICE_NAME,
            "version": VERSION
        }
    )

@app.on_event("shutdown")
async def shutdown_event():
    """Log application shutdown"""
    app_logger.info(
        "Application shutting down",
        extra={
            "service": SERVICE_NAME,
            "version": VERSION
        }
    )

# ============================================================================
# Main (for local development)
# ============================================================================
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_config=None  # Disable uvicorn's default logging
    )


