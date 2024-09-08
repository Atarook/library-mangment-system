pipeline {
    agent any

    environment {
        TF_VERSION = '1.9.5'
        TF_WORKSPACE = 'default'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: 'main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-credentials', url: 'https://github.com/Atarook/library-mangment-system.git']])

            }
        }

        stage('Terraform Init (S3)') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: '657ca1d7-e669-483d-a216-1e509df1ce44']]) {
                    dir('terraform/s3') {
                        bat 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Plan (S3)') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: '657ca1d7-e669-483d-a216-1e509df1ce44']]) {
                    dir('terraform/s3') {
                        bat 'terraform plan -out=tfplan'
                    }
                }
            }
        }

        stage('Terraform Apply (S3)') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: '657ca1d7-e669-483d-a216-1e509df1ce44']]) {
                    dir('terraform/s3') {
                        bat 'terraform apply tfplan'
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: '657ca1d7-e669-483d-a216-1e509df1ce44']]) {
                    dir('terraform') {
                        bat 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: '657ca1d7-e669-483d-a216-1e509df1ce44']]) {
                    dir('terraform') {
                        bat 'terraform plan -out=tfplan'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: '657ca1d7-e669-483d-a216-1e509df1ce44']]) {
                    dir('terraform') {
                        bat 'terraform apply tfplan'
                    }
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
