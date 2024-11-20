pipeline {
    agent any
    
    environment {
        JAVA_VERSION = '11'
        DOCKER_IMAGE = "${env.DOCKER_USERNAME}/frauddetectionsystem"
    }
    
    stages {
        stage('Build and Test') {
            steps {
                sh './scripts/build.sh'
            }
        }
        
        stage('Security Scan') {
            steps {
                sh 'dependency-check.sh --project "FraudDetectionSystem" --scan "." --format "HTML" --out "reports"'
            }
        }
        
        stage('Docker Build and Push') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${env.BUILD_NUMBER}")
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        docker.image("${DOCKER_IMAGE}:${env.BUILD_NUMBER}").push()
                    }
                }
            }
        }
        
        stage('Deploy and Test') {
            steps {
                withCredentials([
                    string(credentialsId: 'db-username', variable: 'DB_USERNAME'),
                    string(credentialsId: 'db-password', variable: 'DB_PASSWORD')
                ]) {
                    sh './scripts/deploy.sh'
                }
            }
        }
    }
    
    post {
        failure {
            mail to: 'henryleungdemotest@gmail.com',
                 subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
                 body: "Something is wrong with ${env.BUILD_URL}"
        }
    }
}