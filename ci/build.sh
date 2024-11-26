#!/bin/bash
set -e

# Ensure the script is run from the project root
cd "$(dirname "$0")/.."

# Ensure DOCKER_USERNAME is set
if [ -z "$DOCKER_USERNAME" ]; then
  echo "DOCKER_USERNAME is not set. Exiting."
  exit 1
fi

# Use a project-specific Java version without changing the global setting
export JAVA_HOME=$HOME/.sdkman/candidates/java/17.0.8-tem
export PATH=$JAVA_HOME/bin:$PATH

# Verify Java version
java -version

# Build the application
echo "Building the application..."
mvn clean package -s custom-settings.xml

# Use GitHub Actions environment variables or default values
IMAGE_TAG=${GITHUB_SHA:-latest}

# Build and push Docker images
services=("config-service" "eureka-server" "gateway-service" "fraud-detection-service")
for service in "${services[@]}"; do
  echo "Building Docker image for $service..."
  docker build -t ${DOCKER_USERNAME}/$service:${IMAGE_TAG} -f $service/Dockerfile $service
  echo "Pushing Docker image for $service to registry..."
  docker push ${DOCKER_USERNAME}/$service:${IMAGE_TAG}
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
  kubectl rollout status deployment/$service --timeout=600s || {
    echo "Deployment of $service failed to become ready. Gathering logs..."
    kubectl describe pods
    kubectl logs -l app=$service --all-containers=true --tail=100
    exit 1
  }
done

echo "Checking deployment status..."
kubectl get deployments,pods,services

echo "Deployment completed successfully."