## BM Project 🔥
Here is A complete CI CD pipeline project supported with the required infrastructure for the AWS cloud
### Tools used 🧰
> Jenkins

> Python Flask

> Sqlite

> Terraform

> SonarQube

> AWS

> Docker

> Kubernetes


## Our Design
![image](https://github.com/user-attachments/assets/7652ca3c-5549-4c83-8b2d-67160ffd28a3)
## Let's explain our code
### Jenkins-init ( Dir )
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

### Terraform ( Dir )
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
### K8S ( Dir )
![image](https://github.com/user-attachments/assets/85c6bbbc-0337-4132-89f3-70621a836785)

    

