pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'moinsalman/devops-task:latest'   // DockerHub repo
        DOCKERHUB_CREDENTIALS = 'dockerhub-creds'                  // Jenkins credentials ID for DockerHub
        GCLOUD_CREDENTIALS = 'gcp-service-account'                 // Jenkins credentials ID for GCP service account (JSON key)
        GCP_PROJECT = 'your-gcp-project-id'
        REGION = 'us-central1'
        SERVICE_NAME = 'your-cloud-run-service'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/salmanmoin10/devops-task.git'
            }
        }
        stage('Test & Build') {
            steps {
                sh 'cat package.json'
                sh 'npm install'
                sh 'npm test'
            }
        }
        stage('Docker Build') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }
        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }
        stage('Deploy to Cloud Run') {
            steps {
                withCredentials([file(credentialsId: "${GCLOUD_CREDENTIALS}", variable: 'GCLOUD_KEY')]) {
                    sh 'gcloud auth activate-service-account --key-file=$GCLOUD_KEY'
                    sh "gcloud config set project ${GCP_PROJECT}"
                    sh "gcloud run deploy ${SERVICE_NAME} --image=${DOCKER_IMAGE} --region=${REGION} --platform=managed --allow-unauthenticated"
                }
            }
        }
    }
    post {
        always {
            sh "docker rmi ${DOCKER_IMAGE} || true"
        }
    }
}
