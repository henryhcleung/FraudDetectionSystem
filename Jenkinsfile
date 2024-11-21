pipeline {
    agent { label 'microservice-build-agent-1' }
    
    environment {
        JAVA_VERSION = '11'
        DEPENDENCY_CHECK_IMAGE = "henryleungdemotest/dependency-check-image:latest"
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'
    }
    
    stages {
        stage('Initialize') {
            steps {
                script {
                    echo 'Initializing pipeline...'
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                    }
                }
            }
        }
        
        stage('Build and Test') {
            steps {
                script {
                    echo 'Building and testing the application...'
                    sh 'mvn clean package -s custom-settings.xml'
                }
            }
        }
        
        stage('Build Security Scan Image') {
            steps {
                script {
                    echo 'Building security scan Docker image...'
                    sh 'docker build -f Dockerfile.dependency-check -t ${DEPENDENCY_CHECK_IMAGE} .'
                }
            }
        }
        
        stage('Security Scan') {
            steps {
                script {
                    echo 'Running security scan...'
                    sh "docker run --rm -v $WORKSPACE:/workspace ${DEPENDENCY_CHECK_IMAGE} /usr/local/bin/dependency-check.sh --project 'FraudDetectionSystem' --scan '/workspace' --format 'HTML' --out '/workspace/reports'"
                }
            }
        }
        
        stage('Docker Build and Push') {
            steps {
                script {
                    echo 'Building Docker image...'
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        def imageTag = "${DOCKER_USERNAME}/frauddetectionsystem:${env.BUILD_NUMBER}"
                        def builtImage = docker.build(imageTag, '-f Dockerfile .')
                        
                        echo 'Pushing Docker image to registry...'
                        docker.withRegistry('https://registry.hub.docker.com', DOCKER_CREDENTIALS_ID) {
                            builtImage.push()
                        }
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
        always {
            script {
                echo 'Cleaning up...'
                sh 'docker logout'
                sh 'docker image prune -f'
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