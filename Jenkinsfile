pipeline {
    agent any

    environment {

         dockerhub = 'docker-config'
         aws = 'aws-config'
         github = 'github-config'
    }
    stages {
        stage('Hello') {
            steps {
                checkout scmGit(branches: [[name: 'main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-config', url: 'https://github.com/Atarook/library-mangment-system.git']])
                sh 'ls -l'
            }
        }
        stage('Build') {
            steps {
                sh "docker build -t ahmedkamal200427400/team4:$BUILD_NUMBER ."
                sh 'docker image ls'
            }
        }

        stage("Push") {
            steps {
                withCredentials([usernamePassword(credentialsId:dockerhub, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                    sh "docker push ahmedkamal200427400/team4:$BUILD_NUMBER"
                }

            }
        }
        stage("Delete Image from EC2") {
            steps {
                sh "docker image remove ahmedkamal200427400/team4:$BUILD_NUMBER"
            }
        }


        stage('Change Deployment') {
            steps {
                
                script {
                    sh "sed -i 's|IMAGE_PLACEHOLDER|ahmedkamal200427400/team4:$BUILD_NUMBER|' ./k8s/deployment.yaml "
                }
            }
            
        }




        stage("Apply Change") {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: aws]]) {
                    sh 'aws eks update-kubeconfig --name team4-eks-cluster --region eu-west-1'
                    sh 'kubectl apply -f ./k8s/pv.yaml'
                    sh 'kubectl apply -f ./k8s/pvc.yaml'
                    sh 'kubectl apply -f ./k8s/deployment.yaml'
                    sh 'kubectl apply -f ./k8s/service.yaml'
                    sh 'sleep 20'
                    sh 'kubectl get services -o wide'
                }
            }
        }

    }

    post {
        always {
            echo 'Pipeline finished'
        }
        failure {
            echo 'Pipeline failed'
        }
    }
}