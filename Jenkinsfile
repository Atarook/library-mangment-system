pipeline {
    agent any

    environment {
        dockerhub = 'docker-config'
        aws = 'aws-config'
        github = 'github-config'
        IMAGE_NAME = "ahmedkamal18/team4:${env.BUILD_NUMBER}"
        // SONAR_SCANNER_HOME = tool 'sonar'
    }

    stages {
        stage('Hello') {
            steps {
                checkout scmGit(branches: [[name: 'master']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-config', url: 'https://github.com/Atarook/library-mangment-system.git']])
                sh 'ls -l'
            }
        }
        
        // stage('SonarQube Analysis') {
        //     steps {
        //         withSonarQubeEnv('sonar') {
        //             sh "${env.SONAR_SCANNER_HOME}/bin/sonar-scanner \
        //                 -Dsonar.projectKey=my_project_key \
        //                 -Dsonar.projectName='My Project' \
        //                 -Dsonar.projectVersion=1.0 \
        //                 -Dsonar.sources= ./
        //                 -Dsonar.host.url=http://localhost:9000 \
        //                 -Dsonar.login=squ_5a2746ee04493cd7fd972f500a949906ec1dd7f3"
        //         }
        //     }
        // }
        
        stage('Setup AWS CLI') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: aws]]) {
                    script {
                        // Configure AWS CLI with environment variables
                        sh 'aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID'
                        sh 'aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY'
                        sh 'aws configure set region eu-west-1'
                        
                        // Verify AWS CLI configuration
                        sh 'aws sts get-caller-identity'
                    }
                }
            }
        }
        
        
        stage('Build') {
            steps {
                sh "docker build -t $IMAGE_NAME ."
                sh 'docker image ls'
            }
        }

        stage("Push") {
            steps {
                withCredentials([usernamePassword(credentialsId:dockerhub, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                    sh "docker push $IMAGE_NAME"
                }
            }
        }

        stage("Delete Image from EC2") {
            steps {
                sh "docker image remove $IMAGE_NAME"
            }
        }

        stage('Change Deployment') {
            steps {
                script {
                    sh "sed -i 's|IMAGE_PLACEHOLDER|$IMAGE_NAME|' ./k8s/deployment.yaml"
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
            script {
                // Manual approval for cleanup
                input message: 'Do you want to proceed with the cleanup?', ok: 'Proceed'
                
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: aws]]) {
                    // Handle cases where the cluster might not exist
                    try {
                        sh 'aws eks update-kubeconfig --name team4-eks-cluster --region eu-west-1'
                        sh 'kubectl delete -f ./k8s/deployment.yaml'
                        sh 'kubectl delete -f ./k8s/service.yaml'
                        sh 'kubectl delete -f ./k8s/pvc.yaml'
                        sh 'kubectl delete -f ./k8s/pv.yaml'
                    } catch (Exception e) {
                        echo "Failed to cleanup Kubernetes resources: ${e.getMessage()}"
                    }
                }
            }
        }

        failure {
            echo 'Pipeline failed'
        }
    }
}