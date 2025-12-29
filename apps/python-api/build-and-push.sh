#!/bin/bash

# Build and push script for python-api
# This script builds the Docker image for linux/amd64 platform (required by ECS Fargate)

set -e

AWS_ACCOUNT_ID="444065722670"
AWS_REGION="us-east-1"
ECR_REPO_NAME="python-api"
IMAGE_TAG="latest"
PROFILE="studying"

# Get the ECR repository URL
ECR_REPO_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}"

echo "🔐 Logging in to ECR..."
aws ecr get-login-password --region ${AWS_REGION} --profile ${PROFILE} | docker login --username AWS --password-stdin ${ECR_REPO_URL}

echo "🏗️  Building Docker image for linux/amd64 platform..."
# Using regular docker build (works better on Mac for cross-platform builds)
# Only tag with ECR URL, not local tag
docker build \
  --platform linux/amd64 \
  -t ${ECR_REPO_URL}:${IMAGE_TAG} \
  .

echo "📤 Pushing image to ECR..."
docker push ${ECR_REPO_URL}:${IMAGE_TAG}

echo "✅ Image built and pushed successfully!"
echo "📍 Image URI: ${ECR_REPO_URL}:${IMAGE_TAG}"

