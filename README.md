# Serverless Container Deployment (AWS ECS Fargate)

This repository contains the Terraform infrastructure code to deploy a containerized web application on AWS Fargate. 

The goal of this architecture was to build a highly available compute layer without the operational overhead of managing EC2 instances, patching operating systems, or configuring auto-scaling groups for virtual machines.

## Architecture Overview

![Architecture Diagram](assets/architecture.jpg)

We route end-user web traffic through an Internet Gateway down to an Application Load Balancer (ALB). The ALB balances traffic across two Availability Zones for high availability. 

The application itself runs as Docker containers managed by AWS ECS Fargate. The ECS tasks pull a custom Nginx image directly from a private Amazon Elastic Container Registry (ECR). 

From a security perspective, we enforce a strict boundary at the Security Group level. Even though the Fargate tasks are assigned public IPs for outbound internet access, their Security Group is configured to drop all direct internet traffic. They only accept HTTP connections if the source is the Load Balancer itself.

## Repository Structure

*   Dockerfile & index.html: Source code for the web container.
*   providers.tf & local.tf: Terraform backend and naming conventions.
*   pc.tf: Network topology, including the custom VPC, subnets, and internet gateway.
*   security.tf: Firewall rules for the ALB and ECS tasks.
*   iam.tf: The IAM execution role allowing Fargate to pull from ECR.
*   ecr.tf: The private container registry.
*   lb.tf: The Application Load Balancer, target groups, and listeners.
*   ecs.tf: The Fargate cluster, task definition, and service configurations.

## Local Deployment Guide

To spin this up in your own AWS account, you need the AWS CLI, Docker, and Terraform installed.

### 1. Build the Container Registry

Because the ECS task will crash if the Docker image does not exist yet, we have to provision the ECR repository first.

`ash
terraform init
terraform apply -target=aws_ecr_repository.app_repo
`

### 2. Push the Docker Image

Authenticate your local Docker daemon with AWS, build the image, and push it to the new registry.

`powershell
$pass = aws ecr get-login-password --region us-east-1
docker login --username AWS --password $pass <YOUR_AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com
docker build -t p6p7-ce-app-repo .
docker tag p6p7-ce-app-repo:latest <YOUR_AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/p6p7-ce-app-repo:latest
docker push <YOUR_AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/p6p7-ce-app-repo:latest
`

### 3. Deploy the Infrastructure

Once the image is staged in ECR, apply the rest of the Terraform code to build the network, load balancer, and compute cluster.

`ash
terraform apply
`

![Working Website](assets/working_website.png)

## Teardown

Fargate and Application Load Balancers incur hourly charges. When you are done testing, run 	erraform destroy to tear down all resources and prevent billing surprises.
