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
          sh "PYTHONUNBUFFERED=1 gcloud builds submit -t ${IMAGE_TAG} ."
        }
      }
    }
        
        stage('Deploy to GKE') {
            steps{
                sh("sed -i.bak 's#gcr.io/universal-torch-305711/helloworld-py:latest#${IMAGE_TAG}#' ./k8s/dev/*.yaml")
                 step([$class: 'KubernetesEngineBuilder', namespace:'ci-cd', projectId: env.PROJECT, clusterName: env.CLUSTER, zone: env.CLUSTER_ZONE, manifestPattern: 'k8s/dev/', credentialsId: env.JENKINS_CRED, verifyDeployments: false])
            }
        }
    }    
}
