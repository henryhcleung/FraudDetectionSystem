   pipeline {
       agent { label 'microservice-build-agent-1' }
       
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
               agent {
                   docker {
                       image 'your-docker-repo/dependency-check-image:latest'
                       args '-v $WORKSPACE:/workspace'
                   }
               }
               steps {
                   sh 'dependency-check.sh --project "FraudDetectionSystem" --scan "/workspace" --format "HTML" --out "/workspace/reports"'
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
                   sh './scripts/deploy.sh'
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