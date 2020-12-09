pipeline {

  environment {
    PROJECT = "deft-manifest-297817"
    APP_NAME = "Python_App"
    FE_SVC_NAME = "${APP_NAME}-frontend"
    CLUSTER = "gke-cluster-ydays-default-pool-793d464d-grp"
    CLUSTER_ZONE = "europe-west1-b"
    IMAGE_TAG = "gcr.io/${PROJECT}/${APP_NAME}:${env.BRANCH_NAME}.${env.BUILD_NUMBER}"
    JENKINS_CRED = "${PROJECT}"
  }

  agent {
    kubernetes {
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
metadata:
labels:
  component: ci
spec:
  # Use service account that can deploy to all namespaces
  serviceAccountName: jenkins
  containers:
  - name: pythonapp
    image: python:latest
    command:
    - cat
    tty: true
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
    stage('Deploy Production') {
      // Production branch
      when { branch 'master' }
      steps{
        container('kubectl') {
        // Change deployed image in canary to the one we just built
          sh("sed -i.bak 's#gcr.io/cloud-solutions-images/gceme:1.0.0#${IMAGE_TAG}#' ./k8s/production/*.yaml")
          step([$class: 'KubernetesEngineBuilder', namespace:'production', projectId: env.PROJECT, clusterName: env.CLUSTER, zone: env.CLUSTER_ZONE, manifestPattern: 'k8s/services', credentialsId: env.JENKINS_CRED, verifyDeployments: false])
          step([$class: 'KubernetesEngineBuilder', namespace:'production', projectId: env.PROJECT, clusterName: env.CLUSTER, zone: env.CLUSTER_ZONE, manifestPattern: 'k8s/production', credentialsId: env.JENKINS_CRED, verifyDeployments: true])
          sh("echo http://`kubectl --namespace=production get service/${FE_SVC_NAME} -o jsonpath='{.status.loadBalancer.ingress[0].ip}'` > ${FE_SVC_NAME}")
        }
      }
    }
  
    
  }
}