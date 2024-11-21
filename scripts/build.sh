#!/bin/bash
set -e

# Ensure the script is run from the project root
cd "$(dirname "$0")/.."

# Ensure DOCKER_USERNAME is set
if [ -z "$DOCKER_USERNAME" ]; then
  echo "DOCKER_USERNAME is not set. Exiting."
  exit 1
fi

# Build the application
echo "Building the application..."
mvn clean package

# Use GitHub Actions environment variables or default values
IMAGE_TAG=${GITHUB_SHA:-latest}

echo "Building Docker image..."
docker build -t ${DOCKER_USERNAME}/fraud-detection-system:${IMAGE_TAG} .

echo "Pushing Docker image to registry..."
docker push ${DOCKER_USERNAME}/fraud-detection-system:${IMAGE_TAG}

echo "Applying Kubernetes manifests..."
sed -e "s|\${DOCKER_USERNAME}|$DOCKER_USERNAME|g" \
    -e "s|\${IMAGE_TAG}|$IMAGE_TAG|g" \
    k8s/deployment.yaml | kubectl apply -f -

kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/configmap.yaml

echo "Waiting for deployment to be ready..."
kubectl rollout status deployment/fraud-detection-system --timeout=600s || {
  echo "Deployment failed to become ready. Gathering logs..."
  kubectl describe pods
  kubectl logs -l app=fraud-detection-system --all-containers=true --tail=100
  exit 1
}

echo "Checking deployment status..."
kubectl get deployments,pods,services

echo "Deployment completed successfully."