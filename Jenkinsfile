pipeline {
    agent { 
        kubernetes {
            label hello
            yaml """
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
    spec:
      containers:
      - name: hello-app
        # Replace GCLOUD_PROJECT with your project ID
        image: gcr.io/deft-manifest-297817/app:latest
        # This app listens on port 81 for web traffic by default.
        ports:
        - containerPort: 81
        env:
          - name: PORT
            value: "81"
"""
   } 
    }
    stages {
        stage('Deploy dev') {
            steps{
                git url: 'https://github.com/MikaDiablo/Ydays-devops/'
                step([$class: 'KubernetesEngineBuilder', 
                        projectId: "deft-manifest-297817",
                        clusterName: "gke-cluster-ydays-default-pool-793d464d-grp",
                        zone: "europe-west1-b",
                        manifestPattern: 'k8s/dev/',
                        credentialsId: "deft-manifest-297817",
                        verifyDeployments: true])
            }
        }
        stage('Wait for SRE Approval') {
         steps{
           timeout(time:12, unit:'HOURS') {
              input message:'Approve deployment?', submitter: 'sre-approvers'
           }
         }
        }
        
    }
}
