pipeline {
    agent { 
            kubernetes {
        label podlabel
        yaml """
kind: Pod
metadata:
  name: jenkins-agent
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    imagePullPolicy: Always
    command:
    - /busybox/cat
    tty: true
    volumeMounts:
      - name: aws-secret
        mountPath: /root/.aws/
      - name: docker-registry-config
        mountPath: /kaniko/.docker
  restartPolicy: Never
  volumes:
    - name: aws-secret
      secret:
        secretName: aws-secret
    - name: docker-registry-config
      configMap:
        name: docker-registry-config
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
