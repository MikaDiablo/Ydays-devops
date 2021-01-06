pipeline {
  agent none

  environment {
    PROJECT = "deft-manifest-297817"
    APP_NAME = "Python_App"
    CLUSTER = "gke-cluster-ydays-default-pool-793d464d-grp"
    CLUSTER_ZONE = "europe-west1-b"
    JENKINS_CRED = "${PROJECT}"
  }

  stages {
    agent {
       kubernetes true

   }
    stage('Deploy  dev') {
      steps{
        container('gcloud') {
          sh("sed -i.bak 's#gcr.io/deft-manifest-297817/app:latest#' ./k8s/dev/deployment.yaml")
          step([$class: 'KubernetesEngineBuilder', namespace:'ci-cd', projectId: env.PROJECT, clusterName: env.CLUSTER, zone: env.CLUSTER_ZONE, manifestPattern: 'k8s/dev', credentialsId: env.JENKINS_CRED, verifyDeployments: false])
          
        }
      }
    }
  
    
  }
}
