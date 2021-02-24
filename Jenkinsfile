pipeline {
  
  agent any
  
  environment {
    PROJECT = "universal-torch-305711"
    APP_NAME = "hello"
    CLUSTER = "gke-cluster-ydays-default-pool-2c9b84aa-grp"
    CLUSTER_ZONE = "us-west1-b"
    JENKINS_CRED = "${PROJECT}"
    CREDENTIALS_ID = 'Kubernetes-ydays'
    IMAGE_TAG = "gcr.io/${PROJECT}/${APP_NAME}:latest"
  }
 
  stages {
   
 
  stage('Test -  Execution of gcloud command') {
    steps{  
        sh "gcloud compute zones --help"
      }
    }

 
    
   stage('Checkout Source') {
      steps {
        checkout scm
      }

    }
 

       

    stage('Deploy dev') {
      
	  steps{
                withCredentials([file(credentialsId: 'gke_secret_file', variable: 'GC_KEY')]) {
                      sh("gcloud auth activate-service-account --key-file=${GC_KEY}")
                       }
             sh("docker pull gcr.io/deft-manifest-297817/helloworld-py:latest")
             step([$class: 'KubernetesEngineBuilder', namespace:'ci-cd', projectId: env.PROJECT, clusterName: env.CLUSTER, zone: env.CLUSTER_ZONE, manifestPattern: '/k8s/dev', credentialsId: 'gke-service-account', verifyDeployments: true])
          
        
      }
    }

  }

}
