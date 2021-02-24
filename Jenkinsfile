pipeline {
    agent { label: "default" }
    stages {
        stage('Deploy to dev') {
            steps{
                git url: 'https://github.com/viglesiasce/sample-app'
                step([$class: 'KubernetesEngineBuilder', 
                        projectId: "universal-torch-305711",
                        clusterName: "gke-cluster-ydays-default-pool-2c9b84aa-grp",
                        zone: "us-west1-b",
                        manifestPattern: 'k8s/dev/',
                        credentialsId: 'Kubernetes-ydays',
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
