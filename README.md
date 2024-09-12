# BM Project 🔥
Here is A complete CI CD pipeline project supported with the required infrastructure for the AWS cloud
## Tools used 🧰
> Jenkins

> Python Flask

> Sqlite

> Terraform

> SonarQube

> AWS

> Docker

> Kubernetes


# Our Design
![image](https://github.com/user-attachments/assets/7652ca3c-5549-4c83-8b2d-67160ffd28a3)
# Let's explain our code
## Jenkins-init ( Dir )
- this directory is for IaC for Jenkins EC2 instance mainly, but it is also supported with
   * AWS CLI
   * SonarQube running on the instance
   * Nginx
   * Docker
   * Terraform
   * Kubectl
   * PiP3
    
- All of that is installed automatically at the initialization of the EC2 instance (init.sh)

![WhatsApp Image 2024-09-09 at 8 48 51 PM](https://github.com/user-attachments/assets/91fe8283-4a17-4d2a-b3d5-0b6dbfd13b81)

- Under that, we needed a strong t2.xlarge EC2 instance having high computing power with 100GB volume to support Jenkins builds
  
![image](https://github.com/user-attachments/assets/c3b93f53-c65b-41f4-91bd-9fdc0b41dad1)

- In the end, all the configurations done in Jenkins are one-time configurations (like installing plugins and setting credentials and pipelines), so we didn't count them as time-consuming jobs

## Terraform ( Dir )
- This directory is the IaC of our main infrastructure
- We used S3 storage for storing the state of our IaC, 😆 in fact, This helped us a lot.

![image](https://github.com/user-attachments/assets/8faf96ea-7c4c-4669-8233-1d277a0f4e05)

- The Hardest thing we faced here was the Volume Attachment, to apply volume attachment we needed to dive in the concepts of AWS EKS addons and how components communicate with each other , but how we solved this problem?
   * After Search we found that we need EBS CSI driver for the EKS to attach volumes

     ![image](https://github.com/user-attachments/assets/6735c4e5-cfb6-4f06-bcdb-d6cd20856b4f)

  * Also we found that this EBS CSI driver needed IAM role with required policies to attach Volumes
 
    ![image](https://github.com/user-attachments/assets/83772049-8673-40a7-9ece-274265df2c85)

  * To attach the role successfully we needed OIDC, so we configured one

  ![image](https://github.com/user-attachments/assets/5cd2c63b-75b0-4bf1-8e2b-1d43e7b5c03d)

  * and this is how we managed to attach volumes successfully
## K8S ( Dir )
![image](https://github.com/user-attachments/assets/85c6bbbc-0337-4132-89f3-70621a836785)

- This Directory contains our important 4 files
    * pv.yaml >> for storage class ( 🚀 yes, we applied dynamic provisioning, 🪄 our volumes are created on demand)
    * pvc.yaml >> this is the claim, connection between deployment and volumes
    * deployment.yaml >> our dynamic pods, we typed this file in a specific way that helps as in the CD pipeline
    * service.yaml >> our 🪨 load balancer
- Here we showed our Skills in working with Kubernetes.

## Pipeline ( Dir )
- Although this is a one-time task, we wanted to show our pipeline creation skills 🥇.
- Jenkinsfile-infra-setup : Creates our pipeline
![WhatsApp Image 2024-09-11 at 11 18 54 PM](https://github.com/user-attachments/assets/d2ed2d8f-c293-4502-afb7-9e4d77d067db)

- Jenkinsfile-Infra-destroy : Destroys our pipeline 😬

## Dockerfile && .dockerignore
- We created a simple DockerFile for containerizing our application and to publish it easily to the registry

![image](https://github.com/user-attachments/assets/6e1e28c4-5c16-40fb-b418-f554bfd49afe)

  
- We tried to minimize and optimize the size of the docker image as we can, so we used ".dockerignore" file

  ![image](https://github.com/user-attachments/assets/63f8a61b-b5f9-4110-bf3e-48ecb6cc4bca)


