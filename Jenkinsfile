pipeline {
    agent { label 'microservice-build-agent-1' }
    
    environment {
        JAVA_VERSION = '11'
        DOCKER_IMAGE = "${env.DOCKER_USERNAME}/frauddetectionsystem"
    }
    
    stages {
        stage('Build and Test') {
            steps {
                script {
                    echo 'Building and testing the application...'
                    sh './scripts/build.sh'
                }
            }
        }
        
        stage('Pull Security Scan Image') {
            steps {
                script {
                    echo 'Pulling security scan Docker image...'
                    sh 'docker pull henryleungdemotest/dependency-check-image:latest'
                }
            }
        }
        
        stage('Security Scan') {
            steps {
                script {
                    echo 'Running security scan...'
                    sh 'docker run --rm -v $WORKSPACE:/workspace henryleungdemotest/dependency-check-image:latest dependency-check.sh --project "FraudDetectionSystem" --scan "/workspace" --format "HTML" --out "/workspace/reports"'
                }
            }
        }
        
        stage('Docker Build and Push') {
            steps {
                script {
                    echo 'Building Docker image...'
                    def builtImage = docker.build("${DOCKER_IMAGE}:${env.BUILD_NUMBER}")
                    
                    echo 'Pushing Docker image to registry...'
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        builtImage.push()
                    }
                }
            }
        }
        
        stage('Deploy and Test') {
            steps {
                script {
                    echo 'Deploying and testing the application...'
                    sh './scripts/deploy.sh'
                }
            }
        }
    }
    
    post {
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