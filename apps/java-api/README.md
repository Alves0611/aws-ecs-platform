# Java API - Spring Boot Observability POC

Backend Java com Spring Boot, logs estruturados em JSON e métricas Prometheus.

## 🚀 Stack

- Java 21
- Spring Boot 3.2.0
- Spring Boot Actuator
- Micrometer Prometheus
- Logback JSON Encoder

## 📦 Instalação

### Pré-requisitos

- Java 21 ou superior
- Maven 3.9 ou superior

### Desenvolvimento Local

```bash
# Compilar e executar
mvn spring-boot:run
```

### Docker

```bash
# Build
docker build -t java-api .

# Run
docker run -p 8000:8000 java-api
```

## 🏃 Executando

### Modo desenvolvimento

```bash
mvn spring-boot:run
```

### Modo produção

```bash
mvn clean package
java -jar target/java-api-1.0.0.jar
```

### Docker

```bash
docker run -p 8000:8000 java-api
```

## 🔍 Endpoints

### Root

```bash
curl http://localhost:8000/
```

Resposta:
```json
{
  "service": "java-api",
  "version": "1.0.0",
  "message": "Java API for observability POC - Spring Boot with structured logging and Prometheus metrics"
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
  "service": "java-api"
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
  "service": "java-api"
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
  "service": "java-api",
  "request_id": "abc-123-def-456"
}
```

**Work (POST) - Simular carga:**
```bash
# Sucesso (sleep 100ms)
curl -X POST http://localhost:8000/api/v1/work \
  -H "Content-Type: application/json" \
  -d '{"sleepMs": 100, "fail": false}'

# Sucesso (sleep 500ms)
curl -X POST http://localhost:8000/api/v1/work \
  -H "Content-Type: application/json" \
  -d '{"sleepMs": 500, "fail": false}'

# Simular falha
curl -X POST http://localhost:8000/api/v1/work \
  -H "Content-Type: application/json" \
  -d '{"sleepMs": 100, "fail": true}'

# Com Request ID customizado
curl -X POST http://localhost:8000/api/v1/work \
  -H "Content-Type: application/json" \
  -H "X-Request-Id: my-custom-id-123" \
  -d '{"sleepMs": 200, "fail": false}'
```

Resposta (sucesso):
```json
{
  "status": "success",
  "durationMs": 102.45,
  "message": "Work completed after 100ms"
}
```

### Métricas Prometheus

```bash
curl http://localhost:8000/actuator/prometheus
```

## 📊 Observabilidade

### Logs Estruturados (JSON)

Todos os logs são emitidos em **stdout** no formato JSON:

```json
{
  "timestamp": "2025-12-26T10:30:45.123Z",
  "level": "INFO",
  "service": "java-api",
  "name": "com.javaapi.app.controller.ApiController",
  "message": "Request completed",
  "request_id": "abc-123-def",
  "method": "GET",
  "path": "/api/v1/hello",
  "status": "200",
  "duration_ms": "12.5"
}
```

**Campos padrão:**
- `timestamp` - ISO 8601 timestamp
- `level` - Log level (INFO, WARN, ERROR)
- `service` - Nome do serviço (java-api)
- `request_id` - UUID único por request (gerado ou via header X-Request-Id)
- `method` - HTTP method
- `path` - Request path
- `status` - HTTP status code
- `duration_ms` - Request duration em milissegundos

### Métricas Disponíveis

Spring Boot Actuator com Micrometer expõe métricas padrão:
- `http_server_requests_seconds` - Latência e contagem de requests HTTP
- `jvm_memory_used_bytes` - Uso de memória JVM
- `jvm_gc_pause_seconds` - Tempo de pausa do GC
- E muitas outras métricas JVM e de aplicação

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

## 🔧 Configuração

### Variáveis de Ambiente

- `SERVER_PORT` - Porta do servidor (padrão: 8000)
- `APP_SERVICE_NAME` - Nome do serviço (padrão: java-api)
- `APP_VERSION` - Versão da aplicação (padrão: 1.0.0)

### application.properties

Veja `src/main/resources/application.properties` para configurações adicionais.

## 📚 Próximos Passos

- [ ] Adicionar OpenTelemetry para tracing distribuído
- [ ] Implementar circuit breaker
- [ ] Adicionar rate limiting
- [ ] Testes unitários e de integração
- [ ] CI/CD pipeline
- [ ] Kubernetes manifests

---

**Feito com ❤️ para estudos de SRE/Platform Engineering**

