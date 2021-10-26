# Kubernetes Go Hello world EKS

[![N|Solid](https://www.bluematador.com/hs-fs/hubfs/www/Icons/bluematador-aws-EKS.png?width=200&name=bluematador-aws-EKS.png)](https://aws.amazon.com/es/eks/)

This tutorial is for Deploy a Go APP Hello World in EKS AWS Kubernetes solution.
  - AWS Account
  - AWS Keys
  - Docker Hub User
  - Github

### Fork the repository
![alt text](https://docs.github.com/assets/images/help/repository/fork_button.jpg)
### Creation of a cluster in AWS 

We need to do this Getting started https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html

```sh
 eksctl create cluster --name Go --nodegroup-name helloworld --node-type t3.medium --nodes 1 --nodes-min 1 --nodes-max 4 --zones us-east-1a,us-east-1b
```

This command creates a Cloudformation Stack that deploys to a EKS.


### Create an ECR cluster

We need to Create an ECR repository https://aws.amazon.com/es/ecr/.


```sh
 aws ecr  create-repository --repository-name helloworld
```
### Create an S3 for Codepipeline
Create an S3 Bucket, replace the xxxxx with some random number 

```sh
 aws s3api create-bucket --bucket codepipeline-us-east-1-xxxxxx
```
## Replace variables in :
replace "*****" Kubernetes/Go/app.deployment.yml with the url of the ECR repo :
```sh
 *******.dkr.ecr.us-east-1.amazonaws.com/helloworld:latest
```
replace "*****" Codebuild/CodeBuild.yaml with your access_key_id and secret_access_key:
```sh
Name: "aws_access_key_id"
Type: "PLAINTEXT"
Value: "********"
Name: "aws_secret_access_key"
Type: "PLAINTEXT"
Value: "********"
```
replace "*****" Codebuild/CodeBuild.yaml with your user for Dockerhub and password
```sh
Name: "dockerhub_username"
Type: "PLAINTEXT"
Value: "********"
Name: "dockerhub_password"
Type: "PLAINTEXT"
Value: "********"
```
replace "*****" Codepipeline/Codepipeline.yaml with your 
OAuthToken of your Github repository.
```sh
 OAuthToken: "******"
 Owner: "******"
```
### Deploy IAM roles
Deploy the IAM Role using cloud formation and CLI.

```sh
 aws cloudformation deploy --template-file Iam.yaml --stack-name IAM-Roles --capabilities CAPABILITY_NAMED_IAM
```
These commands will create the Roles for Codepipeline and Codebuild.
### Deploy CodeBuild 
Deploy the CodeBuild cloud formation using CLI.

```sh
 aws cloudformation deploy --template-file Codebuild/CodeBuild.yaml --stack-name IAM-Roles --capabilities CAPABILITY_NAMED_IAM
```
These commands will create the Codebuild.

### Deploy Codepipeline
Deploy the Codepipeline cloud formation using CLI.

```sh
 aws cloudformation deploy --template-file Codepipeline/Codepipeline.yaml --stack-name IAM-Roles --capabilities CAPABILITY_NAMED_IAM
```
These commands will create the Codepipeline.

![alt text](https://github.com/danf22/EKS-Go-helloworld/blob/master/Codepipeline.PNG)

#### Get information of EKS
Get pods informaton of  EKS:
```sh
 kubectl get pods
```
Get service Information of EKS:
```sh
 kubectl get svc
```
This show the ELB information
![alt text](https://github.com/danf22/EKS-Go-helloworld/blob/master/ELB.PNG)

