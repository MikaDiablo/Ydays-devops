pipeline {

  environment {
    PROJECT = "universal-torch-305711"
    APP_NAME = "app"
    clusterName: "gke-cluster-ydays-default-pool-2c9b84aa-grp"
    CLUSTER = "gke-cluster-ydays-default-pool-2c9b84aa-grp"
    CLUSTER_ZONE = "us-west1-b"
    IMAGE_TAG = "gcr.io/${PROJECT}/${APP_NAME}:${env.BRANCH_NAME}.${env.BUILD_NUMBER}"
    JENKINS_CRED = "${PROJECT}"
  }

  agent {
    kubernetes {
      label 'sample-app'
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
metadata:
labels:
  component: ci
spec:
  # Use service account that can deploy to all namespaces
  serviceAccountName: Compute Engine default service account
  containers:
  - name: gcloud
    image: gcr.io/cloud-builders/gcloud
    command:
    - cat
    tty: true
  - name: kubectl
    image: gcr.io/cloud-builders/kubectl
    command:
    - cat
    tty: true
"""
}
  }
  stages {
    
    stage('Build and push image with Container Builder') {
      steps {
        container('gcloud') {
          sh "PYTHONUNBUFFERED=1 gcloud builds submit -t ${IMAGE_TAG} ."
        }
      }
    }
    stage('Deploy dev') {
      // Canary branch
      when { branch 'dev' }
      steps {
        container('kubectl') {
          sh("sed -i.bak 's#gcr.io/universal-torch-305711/helloworld-py:latest#${IMAGE_TAG}#' ./k8s/dev/*.yaml")
          step([$class: 'KubernetesEngineBuilder', namespace:'ci-cd', projectId: env.PROJECT, clusterName: env.CLUSTER, zone: env.CLUSTER_ZONE, manifestPattern: 'k8s/dev/', credentialsId: env.JENKINS_CRED, verifyDeployments: false])
        }
      }
    }
    
    
  }
}
