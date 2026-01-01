# AWS ECS Multi-Stack Platform

Production-ready containerized microservices platform on AWS ECS Fargate with full IaC, CI/CD, and observability.

## Architecture

![Architecture Diagram](images/ecs.drawio.svg)

## Stack

**Infrastructure**
- Terraform (modular, remote state)
- AWS ECS Fargate
- Application Load Balancer (HTTPS/ACM)
- VPC (multi-AZ, private subnets)
- ECR (image scanning, lifecycle policies)
- CloudWatch Logs

**CI/CD**
- GitHub Actions OIDC (no long-lived credentials)
- Automated builds and deployments

**Applications**
- Python API: FastAPI, Prometheus metrics, structured JSON logging
- Java API: Spring Boot 3.2, Java 21, structured logging
- React: Vite, static SPA

**Observability**
- Structured JSON logging (CloudWatch)
- Prometheus metrics (Python API)
- Health checks (/healthz, /readyz)
- Request tracing (X-Request-Id)
- Auto-scaling (CPU-based, CloudWatch alarms)

## Key Features

- **Infrastructure as Code**: Modular Terraform (00-vpc → 05-github-oidc)
- **Security**: Private subnets, security groups, encrypted ECR, OIDC auth
- **High Availability**: Multi-AZ deployment, ALB with health checks
- **Auto-scaling**: ECS Service Auto Scaling (1-4 tasks per service)
- **Zero-downtime**: Rolling deployments, health check integration
- **Production-ready**: Structured logging, metrics, tracing, monitoring

## Project Structure

```
├── terraform/           # Infrastructure modules
│   ├── 00-vpc/         # VPC, subnets, NAT Gateway
│   ├── 01-ecr/         # Container registries
│   ├── 02-alb/         # Load balancer, ACM, Route53
│   ├── 03-ecs-cluster/ # ECS cluster, capacity providers
│   ├── 04-ecs-service/ # Task definitions, services, auto-scaling
│   └── 05-github-oidc/ # CI/CD authentication
└── apps/               # Application code
    ├── python-api/     # FastAPI service
    ├── java-api/       # Spring Boot service
    └── react/          # Frontend
```

## Quick Start

```bash
# Deploy infrastructure (in order)
cd terraform/00-vpc && terraform apply
cd ../01-ecr && terraform apply
cd ../02-alb && terraform apply
cd ../03-ecs-cluster && terraform apply
cd ../04-ecs-service && terraform apply
cd ../05-github-oidc && terraform apply

# Build and deploy apps (via GitHub Actions or manually)
# Push images to ECR, update task definitions
```

## Services

- **React**: `app.gabrielstudying.click` (port 80)
- **Python API**: `api-python.gabrielstudying.click` (port 8000)
- **Java API**: `api-java.gabrielstudying.click` (port 8000)
