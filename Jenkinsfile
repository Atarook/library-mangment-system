pipeline {
    agent any


    environment {
        dockerhub = 'docker-config'
        aws = 'aws-config'
        github = 'github-config'
        IMAGE_NAME = "ahmedkamal18/team4:${env.BUILD_NUMBER}"
        scannerHome = tool 'sonar'
    }

    stages {
        stage('Hello') {
            steps {
                checkout scmGit(branches: [[name: 'master']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-config', url: 'https://github.com/Atarook/library-mangment-system.git']])
                sh 'ls -l'
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                // Run SonarQube analysis
                withSonarQubeEnv('sonar') {
                    sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=my-project -Dsonar.sources=./"
                    sh """
                        ${env.scannerHome}/bin/sonar-scanner \
                        -Dsonar.projectKey=my_project_key \
                        -Dsonar.projectName='My Project' \
                        -Dsonar.projectVersion=1.0 \
                        -Dsonar.sources=. \
                        -Dsonar.language=python \
                        -Dsonar.login=${env.SONAR_AUTH_TOKEN} \
                        -X
                    """
                }
            }
        }

        // stage('Quality Gate') {
        //     steps {
        //         script {
        //             timeout(time: 1, unit: 'MINUTES') {
        //                 waitForQualityGate abortPipeline: true
        //             }
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
        
        stage("Deploy Website") {
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

        stages {
            stage('Apply Prometheus and Grafana Setup') {
                steps {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: aws]]) {
                        sh 'aws eks update-kubeconfig --name team4-eks-cluster --region eu-west-1'

                        // Apply the namespace YAML
                        sh 'kubectl apply -f ./monitoring/namespace.yaml'

                         // Deploy Prometheus
                        sh 'kubectl apply -f ./monitoring/prometheus-configmap.yaml'
                        sh 'kubectl apply -f ./monitoring/prometheus-pvc.yaml'
                        sh 'kubectl apply -f ./monitoring/prometheus-deployment.yaml'
                        sh 'kubectl apply -f ./monitoring/prometheus-service.yaml'

                        // Deploy Grafana
                        sh 'kubectl apply -f ./monitoring/grafana-secret.yaml'
                        sh 'kubectl apply -f ./monitoring/grafana-pvc.yaml'
                        sh 'kubectl apply -f ./monitoring/grafana-deployment.yaml'
                        sh 'kubectl apply -f ./monitoring/grafana-service.yaml'

                        // Wait for services to start
                        sh 'sleep 20'
                        sh 'kubectl get services -n monitoring -o wide'
                    }
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

                        // Delete Prometheus resources
                        sh 'kubectl delete -f ./monitoring/prometheus-deployment.yaml'
                        sh 'kubectl delete -f ./monitoring/prometheus-service.yaml'
                        sh 'kubectl delete -f ./monitoring/prometheus-pvc.yaml'
                        sh 'kubectl delete -f ./monitoring/prometheus-configmap.yaml'

                        // Delete Grafana resources
                        sh 'kubectl delete -f ./monitoring/grafana-deployment.yaml'
                        sh 'kubectl delete -f ./monitoring/grafana-service.yaml'
                        sh 'kubectl delete -f ./monitoring/grafana-pvc.yaml'
                        sh 'kubectl delete -f ./monitoring/grafana-secret.yaml'

                        // Delete the namespace
                        sh 'kubectl delete namespace monitoring'

                        echo "Cleanup completed."
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