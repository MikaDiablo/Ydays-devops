pipeline {
    agent {
        kubernetes true
    }
    stages {
        stage('Deploy dev') {
            steps{
                git url: 'https://github.com/MikaDiablo/Ydays-devops.git'
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
