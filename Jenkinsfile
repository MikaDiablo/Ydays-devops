pipeline {
    agent any
    environment {
        PROJECT_ID = "static-grid-311307"
        CLUSTER_NAME = 'ydays'
        IMAGE_TAG = "gcr.io/${PROJECT}/${APP_NAME}:${env.BUILD_NUMBER}"
        LOCATION = 'europe-west1-b'
        CREDENTIALS_ID = 'gke-json'
    }
    stages {
        stage("Checkout code") {
            steps {
                checkout scm
            }
        }
        
        stage("SonarQube Analysis") {
    steps{
        
            script {

                    sh "sed -i 's/sonar.projectVersion=build-number/sonar.projectVersion=${BUILD_NUMBER}/g' app-python.properties"
                    sh "sed -i 's@sonar.branch.name=branch_name@sonar.branch.name=dev@g' sonar-project.properties"
                    withSonarQubeEnv('SonarQube') {
                        echo "===========Performing Sonar Scan============"
                        def sonarqubeScannerHome = tool 'SonarQube Scanner 3.3.0.1492'
                        sh "${sonarqubeScannerHome}/bin/sonar-scanner"
                    }
        }
    }
}
        stage('Build and push image with Container Builder') {
      steps {
          script {
          sh "gcloud builds submit --tag gcr.io/static-grid-311307/helloworld-gke:latest"
        }
      }
    }
        
        stage('Deploy to GKE') {
            steps{
                sh("sed -i.bak '#docker pull gcr.io/static-grid-311307/helloworld-gke:latest' k8s/dev/*.yaml")
                step([$class: 'KubernetesEngineBuilder', namespace:'ci-cd', projectId: 'static-grid-311307', clusterName: 'ydays' , zone: 'europe-west1-b', manifestPattern: 'k8s/dev/', credentialsId: 'gke-json', verifyDeployments: false])
                

            }
        }
    }    
}
