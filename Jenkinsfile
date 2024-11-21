pipeline {
    agent { label 'microservice-build-agent-1' }
    
    environment {
        JAVA_VERSION = '11'
        DEPENDENCY_CHECK_IMAGE = "henryleungdemotest/dependency-check-image:latest"
    }
    
    stages {
        stage('Initialize') {
            steps {
                script {
                    echo 'Initializing pipeline...'
                    // Test Docker registry access
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin || exit 1'
                    }
                }
            }
        }
        
        stage('Build and Test') {
            steps {
                script {
                    echo 'Building and testing the application...'
                    sh './scripts/build.sh || exit 1'
                }
            }
        }
        
        stage('Build Security Scan Image') {
            steps {
                script {
                    echo 'Building security scan Docker image...'
                    sh 'docker build -f Dockerfile.dependency-check -t ${DEPENDENCY_CHECK_IMAGE} . || exit 1'
                }
            }
        }
        
        stage('Security Scan') {
            steps {
                script {
                    echo 'Running security scan...'
                    sh 'docker info || exit 1' // Ensure Docker is running
                    sh "docker run --rm -v $WORKSPACE:/workspace ${DEPENDENCY_CHECK_IMAGE} ls -l /workspace || exit 1" // Verify workspace
                    sh """
                        docker run --rm -v $WORKSPACE:/workspace ${DEPENDENCY_CHECK_IMAGE} \
                        /usr/local/bin/dependency-check.sh --project "FraudDetectionSystem" --scan "/workspace" --format "HTML" --out "/workspace/reports" || exit 1
                    """
                }
            }
        }
        
        stage('Docker Build and Push') {
            steps {
                script {
                    echo 'Building Docker image...'
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        def builtImage = docker.build("${DOCKER_USERNAME}/frauddetectionsystem:${env.BUILD_NUMBER}")
                        
                        echo 'Pushing Docker image to registry...'
                        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                            builtImage.push() || exit 1
                        }
                    }
                }
            }
        }
        
        stage('Deploy and Test') {
            steps {
                script {
                    echo 'Deploying and testing the application...'
                    sh './scripts/deploy.sh || exit 1'
                }
            }
        }
    }
    
    post {
        always {
            script {
                echo 'Cleaning up...'
                sh 'docker logout'
            }
        }
        success {
            script {
                echo 'Pipeline completed successfully.'
            }
        }
        failure {
            script {
                echo 'Pipeline failed. Sending notification email...'
                mail to: 'henryleungdemotest@gmail.com',
                     subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
                     body: "Something is wrong with ${env.BUILD_URL}"
            }
        }
    }
}