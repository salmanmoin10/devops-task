pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'moinsalman/devops-task:latest'  // DockerHub repo
        DOCKERHUB_CREDENTIALS = 'dockerhub-creds'      // Jenkins credentials ID for DockerHub
        GCLOUD_CREDENTIALS = 'gcp-service-account'     // Jenkins credentials ID for GCP service account (JSON key)
        GCP_PROJECT = 'arctic-diode-449306-n0'           // Replace with your real GCP project ID
        REGION = 'us-central1'                         // Replace if using a different region
        SERVICE_NAME = 'devops-task-cloudrun'          // Replace with your actual Cloud Run service name
        PATH = "/opt/google-cloud-sdk/bin:$PATH"       // Global PATH for gcloud
    }
    stages {
        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }
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
            sh 'export PATH=$PATH:$HOME/google-cloud-sdk/bin && gcloud auth activate-service-account --key-file=$GCLOUD_KEY'
            sh 'export PATH=$PATH:$HOME/google-cloud-sdk/bin && gcloud config set project ${GCP_PROJECT}'
            sh 'export PATH=$PATH:$HOME/google-cloud-sdk/bin && gcloud run deploy ${SERVICE_NAME} --image=${DOCKER_IMAGE} --region=${REGION} --platform=managed --allow-unauthenticated'
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
