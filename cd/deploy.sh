#!/bin/bash
set -e

# Ensure the script is run from the project root
cd "$(dirname "$0")/.."

# Variables
DOCKER_USERNAME="henryleungdemotest"
IMAGE_TAG="latest"

# Build the JAR file
echo "Building the JAR file..."
mvn clean package

echo "Building and pushing Docker image..."
docker build -t $DOCKER_USERNAME/fraud-detection-system:$IMAGE_TAG .
docker push $DOCKER_USERNAME/fraud-detection-system:$IMAGE_TAG

echo "Applying Kubernetes manifests..."
sed -e "s|\${DOCKER_USERNAME}|$DOCKER_USERNAME|g" \
    -e "s|\${IMAGE_TAG}|$IMAGE_TAG|g" \
    k8s/deployment.yaml | kubectl apply -f -

kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/configmap.yaml

echo "Waiting for deployment to be ready..."
kubectl rollout status deployment/fraud-detection-system --timeout=600s

echo "Checking deployment status..."
kubectl get deployments,pods,services
kubectl describe pods
kubectl logs -l app=fraud-detection-system --all-containers=true --tail=100

echo "Deployment completed successfully."