# Part 1: Infrastructure Setup

This repository contains Terraform configurations for managing Google Cloud Platform (GCP) resources. The structure is organized into modules for better maintainability and scalability.

## Directory Structure
```bash
      eds-terraform-gcp/
      └── devops/
      └── task/
      ├──── main.tf
      ├──── terraform.tfvars.json
      └──── variables.tf
      gcp-resources-code
      └── gcpmodules/
      ├── custom_networking/
      │ ├── main.tf
      │ └── variables.tf
      ├── iam_and_security/
      │ ├── service_account_json/
      │ │ ├── custom_roles/
      │ │ │ ├── main.tf
      │ │ │ └── variables.tf
      │ │ ├── role_bindings/
      │ │ │ ├── main.tf
      │ │ │ └── variables.tf
      │ │ └── service_account/
      │ │ ├──── main.tf
      │ │ ├──── output.tf
      │ │ └──── variables.tf
      │ └── service_account_tfvars/
      │ ├── role_bindings_tfvars/
      │ │ ├── main.tf
      │ │ └── variables.tf
      │ └── service_accounts_tfvars/
      │ ├──── main.tf
      │ ├──── output.tf
      │ └──── variables.tf
      └── kubernetes_cluster/
      ├──── main.tf
      └──── variables.tf
```

## Explanation of the Structure

- **eds-terraform-gcp**: The root directory for your Terraform project.
  
  - **devops**: Contains DevOps-related tasks.
    
    - **task**: Contains Terraform configuration files for deployment.
      - `main.tf`: Main Terraform configuration file.
      - `terraform.tfvars.json`: Variables file in JSON format.
      - `variables.tf`: Variable definitions for the Terraform configuration.

- **gcp-resources-code**: Contains GCP resource modules.
  
  - **gcpmodules**: Directory for GCP module definitions.
    
    - **custom_networking**: Module for custom networking resources.
      - `main.tf`: Main configuration file for the custom networking module.
      - `variables.tf`: Variable definitions for the custom networking module.

    - **iam_and_security**: Module for IAM and security-related resources.
      
      - **service_account_json**: Directory containing service account configurations.
        
        - **custom_roles**: Custom roles related to service accounts.
          - `main.tf`: Main configuration for custom roles.
          - `variables.tf`: Variable definitions for custom roles.

        - **role_bindings**: Role binding configurations.
          - `main.tf`: Main configuration for role bindings.
          - `variables.tf`: Variable definitions for role bindings.

        - **service_account**: Service account configurations.
          - `main.tf`: Main configuration for service accounts.
          - `output.tf`: Outputs from the service account module.
          - `variables.tf`: Variable definitions for service accounts.

      - **service_account_tfvars**: Contains variable files specific to service accounts.
        
        - **role_bindings_tfvars**: Role bindings variable configurations.
          - `main.tf`: Main configuration for role bindings variables.
          - `variables.tf`: Variable definitions for role bindings variables.

        - **service_accounts_tfvars**: Service accounts variable configurations.
          - `main.tf`: Main configuration for service accounts variables.
          - `output.tf`: Outputs from the service accounts variable module.
          - `variables.tf`: Variable definitions for service accounts variables.

    - **kubernetes_cluster**: Module for Kubernetes cluster resources.
      - `main.tf`: Main configuration file for Kubernetes cluster resources.
      - `variables.tf`: Variable definitions for Kubernetes cluster resources.

## Getting Started

### Enable this API before start the proccess

* Cloud Resource Manager API 
    - https://console.cloud.google.com/apis/api/cloudresourcemanager.googleapis.com/metrics?project=edstem-task&inv=1&invt=Abi2ig
* Identity and Access Management (IAM) API 
    - https://console.cloud.google.com/apis/api/iam.googleapis.com/metrics?project=edstem-task
* Compute Engine API 
    - https://console.cloud.google.com/apis/api/compute.googleapis.com/metrics?project=edstem-task
* Kubernetes Engine API 
    - https://console.cloud.google.com/apis/api/container.googleapis.com/metrics?project=edstem-task

### Add the Gcloud key or update the Provider block
  ```bash
   eds-terraform-gcp -> devops -> task -> main.tf -> credentials = file("../../../../../edstem-task.json")
  ``` 

1. Clone this repository:
```bash
   git clone <repository-url>
   cd eds-terraform-gcp/gcp-resources-code/gcpmodules/task/
```

2. Initialize Terraform:
```bash
    terraform init
```

3. Validate the configuration:
```bash
    terraform validate
```

4. Apply the configuration:
```bash
    terraform apply
```



# Kubernetes Deployment for GCP Node.js Application

This repository contains Kubernetes configuration files for deploying a Node.js application on Google Cloud Platform (GCP). The setup includes a ConfigMap, Deployment, Horizontal Pod Autoscaler (HPA), and a LoadBalancer Service.

## Table of Contents
- [Overview](#overview)
- [Directory Structure](#directory-structure)
- [Components](#components)
  - [ConfigMap](#configmap)
  - [Deployment](#deployment)
  - [Horizontal Pod Autoscaler (HPA)](#horizontal-pod-autoscaler-hpa)
  - [Service](#service)
- [Usage](#usage)
- [License](#license)

## Overview
The Kubernetes setup is designed to manage the deployment of a Node.js application efficiently. It utilizes best practices such as environment variable management through ConfigMaps, resource allocation, health checks, and autoscaling based on CPU utilization.

## Directory Structure
```bash
    kubernetes/
    ├── configmap.yaml
    ├── deployment.yaml
    ├── hpa.yaml
    └── service.yaml
```

### Components

### ConfigMap
**File:** `configmap.yaml`

  The ConfigMap stores environment variables for the application.

## Deployment

**File:** `deployment.yaml`
  The Deployment manages the application pods, specifying the container image and resource requirements.

## Service
**File:** `service.yaml'
  The Service exposes the application to external traffic using a LoadBalancer.  


### Deploment Cmds

  To deploy the application in your Kubernetes cluster, follow these steps:

1) Apply the ConfigMap:
```bash
  kubectl apply -f configmap.yaml
```

2) Deploy the Application:
```bash
  kubectl apply -f deployment.yaml
```

3) Set Up Horizontal Pod Autoscaler:
```bash
  kubectl apply -f hpa.yaml
```

4) Expose the Application:
```bash
  kubectl apply -f service.yaml
```

5) Check Status:
```bash
  kubectl get deployments 
  kubectl get services 
  kubectl get hpa 
```


# My Node.js Application

## Overview
This is a simple Node.js application built using Express. It serves a welcome page and includes health check endpoints for liveness and readiness probes, making it suitable for deployment in environments like Kubernetes.

## Features
- Displays a welcome message with the application name and version.
- Health check endpoint for liveness (`/health`).
- Readiness check endpoint (`/ready`).

## Prerequisites
- Docker (version 20 or higher)
- Node.js (for local development, optional)

## Installation
* Clone the repository:
```bash
   git clone https://github.com/yourusername/myapp.git
   cd myapp
   npm install
   node app.js
```

## Running with Docker
-- To build and run the application in a Docker container, follow these steps:
* Build the Docker image:
```bash
  docker build -t nodeapp:1.0 -f DockerFile.mynodeapp  .
```

## Endpoints
  GET /: Displays a welcome message.
  GET /health: Returns OK for liveness checks.
  GET /ready: Returns Ready for readiness checks.

# Jenkins Pipeline for Node.js Application Deployment

## Overview
This project contains a Jenkins pipeline script designed to automate the deployment of a Node.js application to Google Cloud Kubernetes. The pipeline includes stages for checking out source code, authenticating with Google Cloud, building and pushing Docker images, and deploying the application to Kubernetes.

## Features
- **Source Code Management**: Automatically checks out the latest code from a specified GitHub repository.
- **Google Cloud Authentication**: Authenticates with Google Cloud using a service account.
- **Docker Build and Push**: Builds a Docker image and pushes it to Google Container Registry.
- **Kubernetes Deployment**: Supports both fresh deployments and updates to existing deployments.

## Prerequisites
- **Jenkins**: Ensure you have Jenkins installed and running.
- **Plugins**: Install necessary Jenkins plugins:
  - Pipeline
  - Git Plugin
  - Docker Pipeline
  - Kubernetes CLI Plugin
- **Google Cloud SDK**: Ensure `gcloud` is installed and configured on your Jenkins server.
- **Credentials**: Set up the following credentials in Jenkins:
  - `gcloud-service-account`: Service account key file for Google Cloud authentication.
  - `ramkumar-github-nodeapp`: GitHub credentials for accessing the repository.

## Configuration
The pipeline uses a configuration file named `config.properties`. Below is an example of its content:

```properties
# Jenkins-Plugin - Pipeline Utility Steps 
  GCloud_Auth=yes
  Docker_Build_Push=yes
  Fresh_Deploy_nodeapp=yes
  Update_Deploy_nodeapp=no


Configuration Options:
  * GCloud_Auth: Set to yes to enable Google Cloud authentication.
  * Docker_Build_Push: Set to yes to enable Docker image build and push.
  * Fresh_Deploy_nodeapp: Set to yes for fresh deployments to Kubernetes.
  * Update_Deploy_nodeapp: Set to yes for updating existing deployments.


Usage
1) Create a New Pipeline Job:
    - In Jenkins, create a new pipeline job.
    - Point it to your repository containing the Jenkinsfile.
2) Run the Pipeline:
    - Trigger the pipeline manually or configure it to run on SCM changes.

Stages Explained
1. SCM Checkout
    - Checks out the latest code from the specified GitHub repository using the master branch.
2. Google Cloud Authentication
    - Authenticates with Google Cloud if configured in config.properties. It activates the service account using the provided credentials.
3. Docker Build and Push
    - Builds a Docker image from the application source code and pushes it to Google Container Registry. This step can be skipped based on configuration.
4. Fresh Deployment to Kubernetes
    - If enabled, this stage deploys the application as a new deployment in Kubernetes.
5. Update Deployment in Kubernetes
    - Updates an existing deployment with the newly built Docker image if configured.
