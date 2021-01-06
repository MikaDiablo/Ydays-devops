pipeline {
  agent {
      kubernetes {
         label 'hello_world'
         
     }
  }

  environment {
    PROJECT = "deft-manifest-297817"
    APP_NAME = "Python_App"
    CLUSTER = "gke-cluster-ydays-default-pool-793d464d-grp"
    CLUSTER_ZONE = "europe-west1-b"
    JENKINS_CRED = "${PROJECT}"
  }

  stages {
    
    stage('Build and push image with Container Builder') {
      steps {
        container('gcloud') {
          sh "gcloud builds submit --tag gcr.io/project-id/deft-manifest-297817/app ."
        }
      }
    }
    stage('Deploy  dev') {
      steps{
        container('kubectl') {
        // Change deployed image in canary to the one we just built
          sh("sed -i.bak 's#gcr.io/deft-manifest-297817/app:latest#' ./k8s/dev/*.yaml")
          step([$class: 'KubernetesEngineBuilder', namespace:'ci-cd', projectId: env.PROJECT, clusterName: env.CLUSTER, zone: env.CLUSTER_ZONE, manifestPattern: 'k8s/dev', credentialsId: env.JENKINS_CRED, verifyDeployments: true])
          
        }
      }
    }
  
    
  }
}
