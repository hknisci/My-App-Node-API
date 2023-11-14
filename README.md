# Node_API CI/CD Pipeline
## Introduction

This project is designed to streamline the deployment and management process of the Node_API application using a robust Continuous Integration and Continuous Deployment (CI/CD) pipeline tailored for a Kubernetes environment. Our approach utilizes Docker to containerize the Node.js application, ensuring consistent, scalable, and isolated runtime environments.

We leverage Helm, the Kubernetes package manager, to manage the lifecycle of the application within the cluster. Helm simplifies the deployment process by packaging all necessary Kubernetes resources and managing releases of different versions.

The pipeline is automated with GitLab CI, which orchestrates the build and deployment processes upon code commits, ensuring that new changes are automatically built, tested, and deployed to the Kubernetes cluster in a systematic and reliable manner.

Please note that while the integration of the External-Secret structure into the Helm chart was planned to externalize the management of sensitive information, this part of the setup is not currently functional and requires further implementation.

The goal of this project is to demonstrate an efficient CI/CD pipeline setup that promotes rapid development, testing, and deployment cycles, enabling a DevOps approach to application management. The Node_API CI/CD pipeline is an example of modern application deployment strategies that are both agile and secure.


## Requirements

### Continuous Integration (CI)
The CI process is engineered to trigger automated builds of the Node_API application's Docker image upon each commit to the codebase. This ensures that the latest version of the application is packaged and ready for deployment. The CI pipeline performs the following steps:

### Code Analysis: Validates code quality and checks for security vulnerabilities.
Testing: Runs unit and integration tests to ensure code changes do not break existing functionality.
Building: Compiles the source code and builds the Docker image, tagging it with the commit SHA for traceability.
### Continuous Deployment (CD)
CD is facilitated through ArgoCD, which monitors the Git repository for changes to the deployment manifests and automatically synchronizes the desired state of the application in the Kubernetes cluster with the actual state. The CD process encompasses:

- Deployment Manifests: Monitors changes in Helm charts and Kubernetes manifests.
- Synchronization: Keeps the Kubernetes cluster in sync with the repository's defined states.
- Rollout: Manages the rollout of new versions, ensuring zero downtime and providing the ability to rollback if necessary.

### Branch Strategy
The repository is structured around two main branches to support different stages of development:

- master: Serves as the production branch where the stable code is maintained.
- develop: Used for ongoing development and integration of new features.
The pipeline has distinct stages for different actions:

- Build: Compiles the source code into a runnable state.
- Test: Executes automated tests to validate the functionality.
- Deploy: Deploys the application to the respective environment based on the branch.

### Secret Management
Secret management was intended to be handled by External-Secret to enable secure and dynamic handling of sensitive information such as database passwords and API keys. However, due to complexities in managing the external secret structure, this part of the Helm chart is not fully operational. This means that currently:

- Sensitive data might need to be managed manually.
- Helm chart's full potential in terms of dynamic environment management is not realized.

### Container Configuration
The deployment process is designed to allow the container image to be dynamically configured at deployment time. This flexibility means:

Database Endpoint Configuration: The application's container image can be connected to different database endpoints without the need to rebuild or republish the image.
Environment Variability: Supports multiple environments (e.g., staging, production) by allowing for environment-specific configurations to be passed at deployment time.

## Installation

### Prerequisites
Ensure the following tools are installed and configured on your system:

- **Docker**: [Docker Installation Guide](https://docs.docker.com/get-docker/)
- **Kubernetes Cluster**: Set up a Kubernetes cluster where you can deploy your application. For learning and development purposes, you can use Minikube.
- **Helm**: [Helm Installation Guide](https://helm.sh/docs/intro/install/)
- **Minikube**: Minikube is a lightweight Kubernetes implementation that creates a VM on your local machine and deploys a simple cluster containing only one node. Minikube is available for Linux, macOS, and Windows systems. Installation instructions can be found on the [Minikube GitHub page](https://minikube.sigs.k8s.io/docs/start/)
- **GitLab**: Make sure your GitLab repository is set up correctly with access to the repository where the Kubernetes manifests and Helm charts are stored. This includes setting up CI/CD variables, runners, and any necessary permissions.

### Kubernetes Cluster Setup with Minikube

1. **Install Minikube**:
   Follow the instructions on the [Minikube Start Guide](https://minikube.sigs.k8s.io/docs/start/) to install Minikube.

2. **Start Minikube**:
   ```sh
   minikube start
This command starts a single-node Kubernetes cluster.

1. **Verify Cluster**:
Check that the cluster is running with:
   ```sh
   kubectl get nodes
   
2. **Enable Ingress Controller**:
To route traffic to services, enable the ingress controller:
   ```sh
   minikube addons enable ingress

3. **Access Kubernetes Dashboard**:
   ```sh
   minikube dashboard

## Docker Installation Guide

This document outlines the steps necessary to install Docker, which allows you to create, deploy, and run applications in containers — lightweight and portable executable environments.

### Prerequisites

- A 64-bit operating system.
- Check the [Docker compatibility matrix](https://docs.docker.com/engine/install/#supported-platforms) to confirm support for your OS.

### Installation Instructions

#### For Windows Users

1. **Download Docker Desktop for Windows**:
   - Visit [Docker Hub](https://hub.docker.com/editions/community/docker-ce-desktop-windows/) and download the installer.

2. **Run the Installer**:
   - Open the downloaded `.exe` file and follow the on-screen instructions.

3. **Start Docker Desktop**:
   - Launch Docker Desktop via the Start menu.

4. **Verify Installation**:
   - In a command prompt, run `docker --version` to confirm installation.

#### For macOS Users

1. **Download Docker Desktop for Mac**:
   - Go to [Docker Hub](https://hub.docker.com/editions/community/docker-ce-desktop-mac/) and download the `.dmg` file.

2. **Install Docker**:
   - Open the `.dmg` file and drag Docker to the Applications folder.

3. **Run Docker**:
   - Open Docker from the Applications folder or with Spotlight Search.

4. **Verify Installation**:
   - In the terminal, type `docker --version` to check the Docker version.

Congratulations! Docker is now installed and ready for use. For further information, consult the official [Docker documentation](https://docs.docker.com/get-started/).

## Building the Application
This section guides you through the process of setting up the Node_API application on your local development environment.

### **Cloning the Repository**
Start by cloning the repository to your local machine. Open your terminal and execute the following command:
   ```sh
   git clone https://github.com/isNan909/Node_API
   ```
This command creates a directory named Node_API containing the project's source code.

### Configuring server.js:
The server.js file is the heart of your Node.js application, where you can specify configurations:

1. Open the server.js file in a text editor.
2. Search for the configuration block and adjust settings such as:
  - Port numbers
  - Database connections
  - API keys
3. Other environment-specific variables
Save the changes after making your adjustments.

### Setting Up the Database with food.sql
To set up your application's database:

1. Open the food.sql file from the repository.
2. Review and modify the script if necessary to suit your database configuration, such as database names, user credentials, or initial data.
3. Execute the SQL script against your database to establish the schema and populate it with any initial data.

## Dockerfile Explained

The `Dockerfile` is a multi-stage build file, which optimizes the image size by separating the build stage from the production stage.

### Build Stage

```dockerfile
FROM node:14-alpine as builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
```
The build stage uses the lightweight node:14-alpine image, optimized for size. The WORKDIR sets the working directory where the build will take place. Dependencies are installed after copying the package.json and package-lock.json to take advantage of Docker's layer caching, making subsequent builds faster when dependencies don't change. The rest of the application code is copied afterward.

### Production Stage
```
FROM node:14-alpine as production
ENV NODE_ENV=production
WORKDIR /app
COPY --from=builder /app .
RUN npm install --only=production
USER node
EXPOSE 8080
CMD [ "node", "server.js" ]
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD node healthcheck.js
LABEL maintainer="hknisci01@gmail.com"
LABEL version="1.0"
LABEL description="This is the production stage of our multi-stage Docker build."
```
The production stage starts fresh with the same base image to keep the production image lean. It copies the built application from the build stage, then installs only production dependencies. It changes the user to node for security reasons, exposes the application's port, and defines the command to start the application. The health check ensures the application is running and healthy after deployment. Labels provide metadata about the image.

## docker-compose.yml Explained
