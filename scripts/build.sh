#!/bin/bash
set -e

# Use GitHub Actions environment variables or default values
DOCKER_USERNAME=${DOCKER_USERNAME:-$DOCKER_USERNAME}
IMAGE_TAG=${GITHUB_SHA:-latest}

echo "Starting Minikube with adjusted resources..."
minikube start --memory=7000 --cpus=4

echo "Building Docker image..."
docker build -t $DOCKER_USERNAME/fraud-detection-system:$IMAGE_TAG .

echo "Pushing Docker image to registry..."
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