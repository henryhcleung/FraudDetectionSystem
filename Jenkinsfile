pipeline {
    agent { label 'microservice-build-agent-1' }
    
    environment {
        JAVA_VERSION = '11'
        DEPENDENCY_CHECK_IMAGE = "henryleungdemotest/dependency-check-image:latest"
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'
        KUBE_CONFIG_CREDENTIALS_ID = 'kube-config'
        ARTIFACT_NAME = 'FraudDetectionSystem-1.0-SNAPSHOT.jar'
    }
    
    options {
        timeout(time: 1, unit: 'HOURS')
        timestamps()
        ansiColor('xterm')
        disableConcurrentBuilds()
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
                    archiveArtifacts artifacts: "target/${ARTIFACT_NAME}", fingerprint: true
                }
            }
        }
        
        stage('Security Scan') {
            steps {
                script {
                    echo 'Running security scan...'
                    sh "docker run --rm -v $WORKSPACE:/workspace ${DEPENDENCY_CHECK_IMAGE} /usr/local/bin/dependency-check.sh --project 'FraudDetectionSystem' --scan '/workspace' --format 'HTML' --out '/workspace/reports'"
                    publishHTML(target: [
                        allowMissing: false,
                        alwaysLinkToLastBuild: false,
                        keepAll: true,
                        reportDir: 'reports',
                        reportFiles: 'dependency-check-report.html',
                        reportName: 'Dependency Check Report'
                    ])
                }
            }
        }
        
        stage('Docker Build and Push') {
            steps {
                script {
                    echo 'Building Docker image...'
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        def imageTag = "${DOCKER_USERNAME}/fraud-detection-system:${env.BUILD_NUMBER}"
                        def builtImage = docker.build(imageTag, '-f Dockerfile .')
                        
                        echo 'Pushing Docker image to registry...'
                        docker.withRegistry('https://registry.hub.docker.com', DOCKER_CREDENTIALS_ID) {
                            builtImage.push()
                            builtImage.push('latest')
                        }
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    echo 'Deploying to Kubernetes...'
                    withCredentials([file(credentialsId: KUBE_CONFIG_CREDENTIALS_ID, variable: 'KUBECONFIG')]) {
                        sh '''
                            mkdir -p $HOME/.kube
                            cp $KUBECONFIG $HOME/.kube/config
                            kubectl apply -f k8s/configmap.yaml
                            kubectl apply -f k8s/deployment.yaml
                            kubectl apply -f k8s/service.yaml
                            kubectl rollout status deployment/fraud-detection-system
                        '''
                    }
                }
            }
        }
        
        stage('Integration Tests') {
            steps {
                script {
                    echo 'Running integration tests...'
                    sh '''
                        kubectl get pods
                        kubectl get services
                        kubectl wait --for=condition=ready pod -l app=fraud-detection-system --timeout=300s
                        kubectl port-forward service/fraud-detection-system 8080:8080 &
                        sleep 10
                        curl -f http://localhost:8080/health || exit 1
                    '''
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
                cleanWs()
            }
        }
        success {
            script {
                echo 'Pipeline completed successfully.'
                slackSend(color: 'good', message: "Success: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
            }
        }
        failure {
            script {
                echo 'Pipeline failed. Sending notification email'
                mail to: 'henryleungdemotest@gmail.com',
                     subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
                     body: "Something is wrong with ${env.BUILD_URL}"
                slackSend(color: 'danger', message: "Failed: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
            }
        }
    }
}