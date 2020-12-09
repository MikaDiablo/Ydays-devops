pipeline {

  environment {
    PROJECT = "deft-manifest-297817"
    APP_NAME = "Python_App"
    FE_SVC_NAME = "${APP_NAME}-frontend"
    CLUSTER = "gke-cluster-ydays-default-pool-793d464d-grp"
    CLUSTER_ZONE = "europe-west1-b"
    IMAGE_TAG = "gcr.io/${PROJECT}/${APP_NAME}:dev_app.${env.BUILD_NUMBER}"
    JENKINS_CRED = "${PROJECT}"
  }

  agent {
    kubernetes {
      defaultContainer 'jnlp'
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
    
  
    stage('Deploy Dev') {
      // Developer Branches
      when {
        not { branch 'master' }
        not { branch 'dev' }
      }
      steps {
        container('kubectl') {
          // Create namespace if it doesn't exist
          sh("kubectl get ns ci-cd")
          // Don't use public load balancing for development branches
          sh("sed -i.bak 's#LoadBalancer#ClusterIP#' ./k8s/services/frontend.yaml")
          sh("sed -i.bak 's#gcr.io/cloud-solutions-images/Python_App:1.0.0#${IMAGE_TAG}#' ./k8s/dev/*.yaml")
          step([$class: 'KubernetesEngineBuilder', namespace: "ci-cd", projectId: env.PROJECT, clusterName: env.CLUSTER, zone: env.CLUSTER_ZONE, manifestPattern: 'k8s/services', credentialsId: env.JENKINS_CRED, verifyDeployments: false])
          step([$class: 'KubernetesEngineBuilder', namespace: "ci-cd", projectId: env.PROJECT, clusterName: env.CLUSTER, zone: env.CLUSTER_ZONE, manifestPattern: 'k8s/dev', credentialsId: env.JENKINS_CRED, verifyDeployments: false])
          echo 'To access your environment run `kubectl proxy`'
          echo "Then access your service via http://localhost:8001/api/v1/proxy/namespaces/${env.BRANCH_NAME}/services/${FE_SVC_NAME}:80/"
        }
      }
    }
  }
}