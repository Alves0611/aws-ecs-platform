# Python API - FastAPI Observability POC

Backend Python com FastAPI, logs estruturados em JSON e métricas Prometheus.

## 🚀 Stack

- Python 3.12
- FastAPI + Uvicorn
- Prometheus Client
- Python JSON Logger
- Pydantic

## 📦 Instalação

### Desenvolvimento Local

```bash
# Criar virtual environment
python -m venv venv

# Ativar venv
source venv/bin/activate  # Linux/Mac
# venv\Scripts\activate   # Windows

# Instalar dependências
pip install -r requirements.txt
```

### Docker

```bash
# Build
docker build -t python-api .

# Run
docker run -p 8000:8000 python-api
```

## 🏃 Executando

### Modo desenvolvimento (com reload)
```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

### Modo produção
```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 4
```

### Docker
```bash
docker run -p 8000:8000 python-api
```

## 🔍 Endpoints

### Root
```bash
curl http://localhost:8000/
```

Resposta:
```json
{
  "service": "python-api",
  "version": "1.0.0",
  "message": "Python API for observability POC - FastAPI with structured logging and Prometheus metrics"
}
```

### Health Checks

**Liveness:**
```bash
curl http://localhost:8000/healthz
```

Resposta:
```json
{
  "ok": true,
  "service": "python-api"
}
```

**Readiness:**
```bash
curl http://localhost:8000/readyz
```

Resposta:
```json
{
  "ready": true,
  "service": "python-api"
}
```

### API Endpoints

**Hello (GET):**
```bash
# Default
curl http://localhost:8000/api/v1/hello

# Com parâmetro
curl "http://localhost:8000/api/v1/hello?name=SRE"
```

Resposta:
```json
{
  "greeting": "Hello, SRE!",
  "service": "python-api",
  "request_id": "abc-123-def-456"
}
```

**Work (POST) - Simular carga:**
```bash
# Sucesso (sleep 100ms)
curl -X POST http://localhost:8000/api/v1/work \
  -H "Content-Type: application/json" \
  -d '{"sleep_ms": 100, "fail": false}'

# Sucesso (sleep 500ms)
curl -X POST http://localhost:8000/api/v1/work \
  -H "Content-Type: application/json" \
  -d '{"sleep_ms": 500, "fail": false}'

# Simular falha
curl -X POST http://localhost:8000/api/v1/work \
  -H "Content-Type: application/json" \
  -d '{"sleep_ms": 100, "fail": true}'

# Com Request ID customizado
curl -X POST http://localhost:8000/api/v1/work \
  -H "Content-Type: application/json" \
  -H "X-Request-Id: my-custom-id-123" \
  -d '{"sleep_ms": 200, "fail": false}'
```

Resposta (sucesso):
```json
{
  "status": "success",
  "duration_ms": 102.45,
  "message": "Work completed after 100ms"
}
```

### Métricas Prometheus

```bash
curl http://localhost:8000/metrics
```

Exemplo de saída:
```
# HELP http_requests_total Total HTTP requests
# TYPE http_requests_total counter
http_requests_total{method="POST",path="/api/v1/work",service="python-api",status="200"} 42.0

# HELP http_request_duration_seconds HTTP request duration in seconds
# TYPE http_request_duration_seconds histogram
http_request_duration_seconds_bucket{le="0.005",method="POST",path="/api/v1/work",service="python-api"} 0.0
http_request_duration_seconds_bucket{le="0.1",method="POST",path="/api/v1/work",service="python-api"} 15.0
http_request_duration_seconds_bucket{le="0.5",method="POST",path="/api/v1/work",service="python-api"} 42.0
http_request_duration_seconds_sum{method="POST",path="/api/v1/work",service="python-api"} 8.453
http_request_duration_seconds_count{method="POST",path="/api/v1/work",service="python-api"} 42.0

# HELP app_work_jobs_total Total work jobs processed
# TYPE app_work_jobs_total counter
app_work_jobs_total{result="ok",service="python-api"} 39.0
app_work_jobs_total{result="error",service="python-api"} 3.0
```

## 📊 Observabilidade

### Logs Estruturados (JSON)

Todos os logs são emitidos em **stdout** no formato JSON:

```json
{
  "timestamp": "2025-12-26T10:30:45",
  "level": "INFO",
  "service": "python-api",
  "name": "__main__",
  "message": "Request completed",
  "request_id": "abc-123-def",
  "method": "GET",
  "path": "/api/v1/hello",
  "status": 200,
  "duration_ms": 12.5
}
```

**Campos padrão:**
- `timestamp` - ISO 8601 timestamp
- `level` - Log level (INFO, WARNING, ERROR)
- `service` - Nome do serviço (python-api)
- `request_id` - UUID único por request (gerado ou via header X-Request-Id)
- `method` - HTTP method
- `path` - Request path
- `status` - HTTP status code
- `duration_ms` - Request duration em milissegundos

### Métricas Disponíveis

| Métrica | Tipo | Labels | Descrição |
|---------|------|--------|-----------|
| `http_requests_total` | Counter | service, method, path, status | Total de requests HTTP |
| `http_request_duration_seconds` | Histogram | service, method, path | Latência de requests (buckets) |
| `app_work_jobs_total` | Counter | service, result | Jobs processados (ok/error) |

### Request Tracing

O serviço suporta **Request ID** para rastreamento:

1. Se o header `X-Request-Id` for enviado, ele será usado
2. Caso contrário, um UUID será gerado automaticamente
3. O request_id é incluído em todos os logs da request
4. O header `X-Request-Id` é retornado na response

```bash
# Enviar request com ID customizado
curl -H "X-Request-Id: my-trace-123" http://localhost:8000/api/v1/hello

# O response incluirá o header:
# X-Request-Id: my-trace-123
```

## 🧪 Testes de Carga

### Script simples (bash)
```bash
#!/bin/bash
for i in {1..100}; do
  curl -s "http://localhost:8000/api/v1/hello?name=User$i" &
done
wait
```

### Com wrk
```bash
# Instalar: brew install wrk (Mac) ou apt install wrk (Linux)
wrk -t4 -c100 -d30s http://localhost:8000/api/v1/hello
```

### Com Apache Bench
```bash
ab -n 1000 -c 10 http://localhost:8000/api/v1/hello
```

### Script de carga para /work
```bash
#!/bin/bash
echo "Gerando carga em /api/v1/work..."
for i in {1..50}; do
  curl -s -X POST http://localhost:8000/api/v1/work \
    -H "Content-Type: application/json" \
    -d "{\"sleep_ms\": $((RANDOM % 500)), \"fail\": false}" &
done
wait
echo "Carga concluída!"
```

## 📈 Integração com Prometheus

### Configuração prometheus.yml
```yaml
scrape_configs:
  - job_name: 'python-api'
    scrape_interval: 15s
    static_configs:
      - targets: ['localhost:8000']
        labels:
          service: 'python-api'
          environment: 'local'
    metrics_path: '/metrics'
```

### Queries úteis (PromQL)

```promql
# Taxa de requests por segundo
rate(http_requests_total{service="python-api"}[5m])

# P95 de latência
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket{service="python-api"}[5m]))

# Taxa de erro (5xx)
sum(rate(http_requests_total{service="python-api",status=~"5.."}[5m])) / sum(rate(http_requests_total{service="python-api"}[5m]))

# Jobs com sucesso vs erro
rate(app_work_jobs_total{service="python-api"}[5m])
```

## 🔍 Integração com Loki

### Coletando logs com Promtail

**promtail-config.yml:**
```yaml
scrape_configs:
  - job_name: python-api
    static_configs:
      - targets:
          - localhost
        labels:
          job: python-api
          __path__: /var/log/python-api/*.log
    pipeline_stages:
      - json:
          expressions:
            timestamp: timestamp
            level: level
            service: service
            request_id: request_id
            method: method
            path: path
            status: status
            duration_ms: duration_ms
            message: message
      - labels:
          level:
          service:
          method:
      - timestamp:
          source: timestamp
          format: '2006-01-02T15:04:05'
```

### Redirecionar logs para arquivo
```bash
# Desenvolvimento
uvicorn app.main:app --host 0.0.0.0 --port 8000 2>&1 | tee python-api.log

# Produção (com logrotate)
mkdir -p /var/log/python-api
uvicorn app.main:app --host 0.0.0.0 --port 8000 >> /var/log/python-api/app.log 2>&1
```

### Queries úteis (LogQL)

```logql
# Todos os logs do serviço
{service="python-api"}

# Apenas errors
{service="python-api"} | json | level="ERROR"

# Requests lentos (> 1000ms)
{service="python-api"} | json | duration_ms > 1000

# Por request_id
{service="python-api"} | json | request_id="abc-123"

# Taxa de requests por minuto
rate({service="python-api"} | json | __error__="" [1m])
```

## 🐳 Docker Compose (opcional)

```yaml
version: '3.8'

services:
  python-api:
    build: .
    ports:
      - "8000:8000"
    environment:
      - LOG_LEVEL=INFO
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/healthz"]
      interval: 30s
      timeout: 3s
      retries: 3
      start_period: 5s
```

## 🔧 Troubleshooting

### Porta 8000 já em uso
```bash
# Descobrir processo usando a porta
lsof -i :8000

# Matar processo
kill -9 <PID>

# Ou rodar em outra porta
uvicorn app.main:app --host 0.0.0.0 --port 8001
```

### Logs não aparecem em JSON
Verifique se não há outro handler configurado. O código remove handlers padrão e adiciona o JSON handler.

### Métricas não aparecem
Verifique se o endpoint `/metrics` está acessível:
```bash
curl -v http://localhost:8000/metrics
```

## 📚 Próximos Passos

- [ ] Adicionar OpenTelemetry para tracing distribuído
- [ ] Implementar circuit breaker
- [ ] Adicionar rate limiting
- [ ] Testes unitários e de integração
- [ ] CI/CD pipeline
- [ ] Kubernetes manifests

---

**Feito com ❤️ para estudos de SRE/Platform Engineering**


