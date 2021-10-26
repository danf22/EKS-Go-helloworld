terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_codepipeline" "CodePipelinePipeline" {
    name = "Go-helloworld"
    role_arn = "arn:aws:iam::517787923146:role/service-role/AWSCodePipelineServiceRole-us-east-1-Go-helloworld"
    artifact_store {
        location = "codepipeline-us-east-1-21127976748"
        type = "S3"
    }
    stages {
        name = "Source"
        action = [
            {
                name = "Source"
                category = "Source"
                owner = "ThirdParty"
                configuration {
                    Branch = "master"
                    OAuthToken = "****"
                    Owner = "***"
                    PollForSourceChanges = "true"
                    Repo = "EKS-Go-helloworld"
                }
                provider = "GitHub"
                version = "1"
                output_artifacts = [
                    "SourceArtifact"
                ]
                run_order = 1
            }
        ]
    }
    stages {
        name = "Build"
        action = [
            {
                name = "Build"
                category = "Build"
                owner = "AWS"
                configuration {
                    ProjectName = "Build"
                }
                input_artifacts = [
                    "SourceArtifact"
                ]
                provider = "CodeBuild"
                version = "1"
                output_artifacts = [
                    "BuildArtifact"
                ]
                run_order = 1
            }
        ]
    }
    stages {
        name = "Deploy"
        action = [
            {
                name = "Deploy"
                category = "Build"
                owner = "AWS"
                configuration {
                    ProjectName = "Deploy-eks"
                }
                input_artifacts = [
                    "SourceArtifact"
                ]
                provider = "CodeBuild"
                version = "1"
                run_order = 1
            }
        ]
    }
}
