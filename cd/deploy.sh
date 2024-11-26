#!/bin/bash
set -e

# Ensure the script is run from the project root
cd "$(dirname "$0")/.."

# Load SDKMAN
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Use the project-specific Java version
sdk use java 17.0.8-tem

# Variables
DOCKER_USERNAME="your-docker-repo"
IMAGE_TAG="latest"

# Build the JAR files
echo "Building the JAR files..."
mvn clean package -s custom-settings.xml

# Build and push Docker images
services=("config-service" "eureka-server" "gateway-service" "fraud-detection-service")
for service in "${services[@]}"; do
  echo "Building and pushing Docker image for $service..."
  docker build -t $DOCKER_USERNAME/$service:$IMAGE_TAG -f $service/Dockerfile $service
  docker push $DOCKER_USERNAME/$service:$IMAGE_TAG
done

# Apply Kubernetes manifests
echo "Applying Kubernetes manifests..."
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/config-service-deployment.yaml
kubectl apply -f k8s/config-service-service.yaml
kubectl apply -f k8s/eureka-server-deployment.yaml
kubectl apply -f k8s/eureka-server-service.yaml
kubectl apply -f k8s/gateway-service-deployment.yaml
kubectl apply -f k8s/gateway-service-service.yaml
kubectl apply -f k8s/fraud-detection-service-deployment.yaml
kubectl apply -f k8s/fraud-detection-service-service.yaml

# Wait for deployments to be ready
for service in "${services[@]}"; do
  echo "Waiting for deployment of $service to be ready..."
  kubectl rollout status deployment/$service --timeout=600s
done

echo "Checking deployment status..."
kubectl get deployments,pods,services
kubectl describe pods
kubectl logs -l app=fraud-detection-service --all-containers=true --tail=100

echo "Deployment completed successfully."