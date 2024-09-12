# BM Project 🔥
Here is A complete CI CD pipeline project supported with the required infrastructure for the AWS cloud

# Demo Video 
- Here is the summary of our project, we supported our pipeline with a web hook from GitHub to Jenkins EC2 instance
  


https://github.com/user-attachments/assets/1aca5483-ae9f-4a86-a1f2-3db5ac61450b


## Tools used 🧰
## Tools & Technologies

[![jenkins][jenkins]][jenkins-url] [![flask][flask]][flask-url] 
[![sqlite][sqlite]][sqlite-url] [![terraform][terraform]][terraform-url]
[![sonarqube][sonarqube]][sonarqube-url] [![aws][aws]][aws-url] 
[![docker][docker]][docker-url] [![kubernetes][kubernetes]][kubernetes-url]
[![aws-cli][aws-cli]][aws-cli-url] [![nginx][nginx]][nginx-url] 
[![kubectl][kubectl]][kubectl-url] [![pip][pip]][pip-url]
[![python][python]][python-url] [![linux][linux]][linux-url] [![bash][bash]][bash-url]

[jenkins]: https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white
[jenkins-url]: https://www.jenkins.io/

[flask]: https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white
[flask-url]: https://flask.palletsprojects.com/

[sqlite]: https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white
[sqlite-url]: https://www.sqlite.org/

[terraform]: https://img.shields.io/badge/Terraform-623CE4?style=for-the-badge&logo=terraform&logoColor=white
[terraform-url]: https://www.terraform.io/

[sonarqube]: https://img.shields.io/badge/SonarQube-4E9BCD?style=for-the-badge&logo=sonarqube&logoColor=white
[sonarqube-url]: https://www.sonarqube.org/

[aws]: https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazonaws&logoColor=white
[aws-url]: https://aws.amazon.com/

[docker]: https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white
[docker-url]: https://www.docker.com/

[kubernetes]: https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white
[kubernetes-url]: https://kubernetes.io/

[aws-cli]: https://img.shields.io/badge/AWS%20CLI-232F3E?style=for-the-badge&logo=amazonaws&logoColor=white
[aws-cli-url]: https://aws.amazon.com/cli/

[nginx]: https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white
[nginx-url]: https://www.nginx.com/

[kubectl]: https://img.shields.io/badge/Kubectl-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white
[kubectl-url]: https://kubernetes.io/docs/reference/kubectl/

[pip]: https://img.shields.io/badge/Pip-3776AB?style=for-the-badge&logo=pypi&logoColor=white
[pip-url]: https://pip.pypa.io/en/stable/

[python]: https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white
[python-url]: https://www.python.org/

[linux]: https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black
[linux-url]: https://www.linux.org/

[bash]: https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white
[bash-url]: https://www.gnu.org/software/bash/

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


# Our Pipeline 💘
- An optimized automated pipeline supported with lead approval

  ![WhatsApp Image 2024-09-12 at 2 10 08 AM](https://github.com/user-attachments/assets/a9bd1a43-75e7-4b05-bc0f-c663aaaee310)

- What does our pipeline do?
  * Checkout code from GitHub repo ☑️
  * Apply Quality Assurance on it using SonarQube ☑️

    ![WhatsApp Image 2024-09-12 at 2 00 44 AM](https://github.com/user-attachments/assets/b6d7ba79-7844-47d0-b260-16b085a4e403)

  * Build DockerFile and Push it to DockerHub 🐬
  * Change Deployment.yaml File according to the image name on the registry 🛳️
  * Apply those changes to our EKS cluster on AWS 🌩️
  * Finished ♾️
- How is our pipeline optimized? is deletes the image built from Jenkins EC2 to save resources. 🪗

# Contributors
<a href="https://github.com/Atarook/library-mangment-system/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=Atarook/library-mangment-system" />
</a>


