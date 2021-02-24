pipeline {
    agent any
    environment {
        PROJECT_ID = "universal-torch-305711"
        CLUSTER_NAME = 'cluster-ydays'
        IMAGE_TAG = "gcr.io/${PROJECT}/${APP_NAME}:${env.BUILD_NUMBER}"
        LOCATION = 'us-west1-b'
        CREDENTIALS_ID = 'Kubernetes-ydays'
    }
    stages {
        stage("Checkout code") {
            steps {
                checkout scm
            }
        }
        stage('Build and push image with Container Builder') {
      steps {
          script {
          sh "gcloud builds submit --tag gcr.io/universal-torch-305711/helloworld-gke:latest ."
        }
      }
    }
        
        stage('Deploy to GKE') {
            steps{
                sh "kubectl create deployment hello-app --image=gcr.io/universal-torch-305711/helloworld-gke:latest"
                sh "kubectl scale deployment hello-app --replicas=2"
                

            }
        }
    }    
}
