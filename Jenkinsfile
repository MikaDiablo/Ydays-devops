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
                sh("sed -i.bak 's#docker pull gcr.io/universal-torch-305711/helloworld-gke:latest' k8s/dev/*.yaml")
                step([$class: 'KubernetesEngineBuilder', namespace:'ci-cd', projectId: 'universal-torch-305711', clusterName: 'gke-cluster-ydays-default-pool-2c9b84aa-grp' , zone: 'us-west1-b', manifestPattern: 'k8s/dev/', credentialsId: 'Kubernetes-ydays', verifyDeployments: false])
                

            }
        }
    }    
}
