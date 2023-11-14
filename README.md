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
```dockerfile
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
The docker-compose.yml file defines a multi-container Docker application, making it easy to launch complex environments.

### Services Configuration
```yaml
services:
  db:
    image: postgres:latest
```
A PostgreSQL database is set up as a service, which is a common requirement for applications that persist data.
```yaml
    environment:
      POSTGRES_DB: foodie
      POSTGRES_USER: api_user
      POSTGRES_PASSWORD: root
```
Environment variables are used to configure the database according to the application's needs without hardcoding values into the image.
```yaml
    volumes:
      - db_data:/var/lib/postgresql/data
      - ./queries/food.sql:/docker-entrypoint-initdb.d/create_tables.sql
```
Persistent storage is defined for the database data, and an initialization script is provided to set up the schema on first launch.
```yaml
  app:
    build:
      context: .
      dockerfile: Dockerfile
```
The application service is built using the Dockerfile in the current context, ensuring that any changes in the Dockerfile will be reflected in the built image.
```yaml
    depends_on:
      - db
```
Specifies a dependency on the database service, meaning the app service will only start after the db service is up and running.
```yaml
    environment:
      - NODE_ENV=production
      - DB_HOST=db
      ...
```
The application is configured for production with environment variables that point to the database service for connections.
```yml
    healthcheck:
      test: ["CMD", "node", "healthcheck.js"]
      ...
```
A health check is also included for the application service, similar to the Dockerfile configuration.

### Volumes Configuration
```yaml
volumes:
  db_data:
```
A named volume is created for the PostgreSQL data, which ensures that the database state is maintained across container restarts and updates.

## Running with docker-compose
To run the services defined in the docker-compose.yml file:
```sh
docker-compose up
```
This command will start all services defined in the file. If there are changes in the Dockerfile or the build context, docker-compose will rebuild the image automatically. It also starts the containers with their configured volumes, environment variables, and dependencies.

For a production environment, you might want to run the services in detached mode:
```sh
docker-compose up -d
```
This will start the services in the background, allowing you to continue using the terminal. You can view the logs for each service with docker-compose logs and stop the services with 
```sh
docker-compose down
```

## GitLab
### Comprehensive Project Guide
This part provides an in-depth guide covering the implementation of Two-Factor Authentication in GitLab, utilizing GitLab's Container Registry, and the process of Dockerizing a Node.js application followed by its deployment using GitLab CI/CD.
### Table of Contents
1.	Implementing Two-Factor Authentication in GitLab
2.	Utilizing GitLab's Container Registry
3.	Dockerizing and Deploying a Node.js App with GitLab CI/CD
________________________________________
### Implementing Two-Factor Authentication in GitLab
[GitLab's Two-Factor Authentication Documentation](https://docs.gitlab.com/ee/user/profile/account/two_factor_authentication.html)

Step-by-Step Guide:
1.	Understanding 2FA: Learn about the importance of adding an extra security layer to your GitLab account.
2.	Choosing 2FA Methods: Decide between TOTP and WebAuthn devices.
3.	Enabling 2FA in GitLab:
  -	Navigate to your user settings.
  -	Follow the instructions to enable 2FA.
4.	Using Personal Access Tokens: Replace your password with personal access tokens for Git over HTTPS or GitLab API.
5.	Managing Recovery Codes: Securely store your recovery codes for emergency access.
6.	Disabling 2FA: Understand the steps to disable 2FA if needed.
________________________________________
### Utilizing GitLab's Container Registry
[GitLab Container Registry Documentation](https://docs.gitlab.com/ee/user/packages/container_registry/)
Detailed Instructions:
1.	Enabling the Registry: Steps to enable the Container Registry in your GitLab instance.
2.	Working with Dependency Proxy: Use the Dependency Proxy for Docker Hub to avoid rate limits.
3.	Registry Management:
  -	View and manage container images through the GitLab UI.
  -	Learn to search, sort, filter, and delete images and tags.
4.	Using Container Images: Steps to download and run images from the registry.
5.	Visibility and Permissions: Adjusting the visibility and permissions of your Container Registry.
________________________________________
### Dockerizing and Deploying a Node.js App with GitLab CI/CD
[Guide by Taylor Callsen](https://taylor.callsen.me/how-to-dockerize-a-nodejs-app-and-deploy-it-using-gitlab-ci/)
Comprehensive Process
1.	Creating the Node.js App: Start with a simple REST API using Express.
2.	Writing the Dockerfile: Define the steps to package your app into a Docker image.
3.	Setting Up the Staging Server: Prepare your server for SSH deployments and configure Apache for web requests.
4.	Configuring GitLab:
  - Create a new project in GitLab.
  - Set up and configure Runners.
  - Define CI/CD variables like server IP and SSH keys.
5.	Building the CI/CD Pipeline:
  - Add a gitlab-ci.yaml file to your project.
  - Define stages for building and deploying the Docker image.
6.	Security Practices: Implement best practices for key management and SSH access.
Additional Tips:
  - Troubleshooting: Common issues and their solutions.
  - Best Practices: Security-focused recommendations for Docker deployments.
________________________________________
## .gitlab-ci.yml File Explanation
This file is a configuration for GitLab's CI/CD pipeline, defining how the software is built, tested, and deployed.

### Stages
The pipeline is divided into three stages: build, test, and deploy.
```yaml
stages:
  - build
  - test
  - deploy
```
#### Build Stage
Purpose: To create a Docker image of the application.
Image Used: docker:19.03.12.
Services: Docker-in-Docker (docker:dind) is used to allow Docker commands within the Docker executor.
Script:
   - Builds a Docker image with the tag $IMAGE_TAG.
   - Pushes the image to a registry.
Branches: This job runs only on the master and develop branches.
#### Test Stage
Purpose: To run tests in the application.
Image Used: docker:19.03.12.
Services: Docker-in-Docker (docker:dind).
Script:
   - Installs dependencies and runs tests using a Node.js Docker image.
Artifacts:
   - Stores test results for one week.
Branches: Runs only on master and develop.
#### Deploy Stage
Divided into: deploy_staging and deploy_production.
Image Used: docker:19.03.12.
Services: Docker-in-Docker (docker:dind).
##### Deploy to Staging
Environment: staging.
Script:
   - Uses docker-compose to deploy the application.
   - Branch: Runs only on develop.
#### Deploy to Production
Environment: production.
Manual Trigger: Deployment to production requires a manual trigger.
Script:
   - Deploys the application and checks if the app service is running.
Branch: Runs only on master.
### Variables
Global variables used across all stages.
```yaml
variables:
  IMAGE_TAG: $CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG
  DOCKER_HOST: "tcp://docker:2376"
  ...
  KUBE_NAMESPACE: if $CI_COMMIT_BRANCH == "master" then "production" else "staging"
```
IMAGE_TAG: Defines the Docker image tag.
DOCKER_HOST and related variables: Configures Docker-in-Docker.
KUBE_NAMESPACE: Sets the Kubernetes namespace based on the branch.
### Before Script
Commands that run before each job's script.
```yaml
before_script:
  - echo "Starting CI/CD Pipeline for $CI_COMMIT_REF_NAME"
  - echo "$CI_REGISTRY_PASSWORD" | docker login -u "$CI_REGISTRY_USER" --password-stdin $CI_REGISTRY
```
### build Job
This job is part of the build stage and is responsible for creating the Docker image of the application.
```yaml
build:
  stage: build
  image: docker:19.03.12
  services:
    - docker:dind
  script:
    - echo "Building Docker image with tag $IMAGE_TAG"
    - docker build -t $IMAGE_TAG .
    - docker push $IMAGE_TAG
  only:
    - master
    - develop
```
Image & Services: Uses Docker 19.03.12 and Docker-in-Docker service.
Script:
   - Builds the Docker image tagged with $IMAGE_TAG.
   - Pushes the image to the Docker registry.
Branches: Executes only on master and develop branches.
### test Job
This job runs automated tests in the application.
```yaml
test:
  stage: test
  image: docker:19.03.12
  services:
    - docker:dind
  script:
    - echo "Running tests"
    - docker run --rm -v $(pwd):/app -w /app node:14-alpine npm install
    - docker run --rm -v $(pwd):/app -w /app node:14-alpine npm test
  artifacts:
    paths:
      - test_results/
    expire_in: 1 week
  only:
    - master
    - develop
```
Image & Services: Uses the same Docker image and service as the build job.
Script:
   - Runs a Node.js container to install dependencies and execute tests.
Artifacts: Stores test results for one week.
Branches: Limited to master and develop.
### deploy_staging Job
This job handles the deployment of the application to the staging environment.
```yaml
deploy_staging:
  stage: deploy
  image: docker:19.03.12
  services:
    - docker:dind
  environment:
    name: staging
  before_script:
    - apk add --no-cache docker-compose
  script:
    - echo "Deploying to staging environment"
    - docker-compose -f docker-compose.yml up -d
  only:
    - develop
```
Environment: Specifies the deployment environment as staging.
Before Script: Installs docker-compose.
Script: Uses docker-compose to deploy the application.
Branch: Executes only on the develop branch.
### deploy_production Job
This job is for deploying the application to the production environment.
```yaml
deploy_production:
  stage: deploy
  image: docker:19.03.12
  services:
    - docker:dind
  environment:
    name: production
  before_script:
    - apk add --no-cache docker-compose
  script:
    - echo "Deploying to production environment"
    - docker-compose -f docker-compose.yml up -d
    - |
      if ! docker-compose ps | grep 'app'; then
        echo "Deployment failed: app service is not running."
        exit 1
      fi
  when: manual
  only:
    - master
```
Environment: Set to production.
Manual Trigger: Deployment to production requires manual approval.
Script:
   - Deploys using docker-compose.
   - Checks if the app service is running, and exits with an error if not.
Branch: Limited to the master branch.
This .gitlab-ci.yml file is a comprehensive example of a multi-stage CI/CD pipeline, showcasing build, test, and deployment processes with Docker and GitLab CI/CD.
________________________________________
After these review and configuration steps, I want to illustrate with a working example:

## Jobs
![image](https://github.com/hknisci/My-App-Node-API/assets/73697911/ddfea773-2c10-47f8-aa96-a99c11692a26)

## Container Registry
![image](https://github.com/hknisci/My-App-Node-API/assets/73697911/e1a2eb17-b7fb-44be-9aae-9fe1c2478f22)

## Environment
![image](https://github.com/hknisci/My-App-Node-API/assets/73697911/75a65801-10e0-4d8b-b649-6468c4c046d1)
________________________________________
## Helm Chart
In the dynamic landscape of Kubernetes, I have meticulously designed a Helm chart that stands as a beacon of best practices, operational efficiency, and strategic foresight. Let me guide you through the nuances of my creation, a chart that not only manages the lifecycle of a Kubernetes application but does so with unmatched elegance and precision.

### The Essence of My Design
1. Chart.yaml - The Identity of My Creation: This file is the essence of my Helm chart, containing vital metadata like the chart's name, version, and a succinct description. It serves as the identity badge of my chart, ensuring that it is easily recognizable and well-documented.

2. The Trilogy of Configuration - values.yaml, values-staging.yaml, values-production.yaml: Here, I have crafted a versatile configuration system. These files are the heart of my chart's templating power, allowing me to tailor deployments for various environments. My objective here was to create a balance between consistency across deployments and the flexibility needed for each unique environment.

3. Templates Directory - The Architectural Backbone:

   - deployment.yaml: Here, I define how my application's life cycle should be managed, ensuring seamless updates and uninterrupted availability.
   - service.yaml: This is where I set up the access points for my application, crucial for both internal and external communications.
   - ingress.yaml: I use this file to manage external access, directing traffic to ensure my application is accessible through well-defined routes.
   - hpa.yaml (Horizontal Pod Autoscaler): My focus here is on performance stability, enabling dynamic scaling of pods to maintain an optimal balance between demand and resource availability.
   - secrets.yaml: In this file, I prioritize the security of sensitive data, a critical aspect of my deployment's integrity.
   - serviceaccount.yaml: Here, I enhance security and control by managing the identities for processes running in my Pods.
   - configmap.yaml: This is where I store non-confidential configuration data, allowing for dynamic and flexible application configuration.
   - _helpers.tpl: My repository of reusable templates, crafted to promote efficiency and ease of maintenance across my chart.
   - .helmignore - The Sentinel: I have carefully curated this file to ensure that only the necessary elements are packaged into my Helm chart, keeping it secure and clean.

4. Test-Connection.yaml - My Seal of Operational Excellence: This component of my chart is crucial. It validates that my deployment is not just successfully deployed but also functioning optimally within the Kubernetes environment.

### My Objectives and Benefits
- Architectural Symphony and Scalability: I designed my chart to be modular and scalable, accommodating the evolving needs of my application with ease and flexibility.

- Customized Precision Across Environments: My approach ensures uniformity across deployments while allowing for tailored configurations in different environments. This results in reduced deployment discrepancies and enhanced predictability.

- Unwavering Commitment to Security: In managing my Helm chart, I adhere to the highest standards of security practices, ensuring the safety and compliance of my data.

- Adaptive Performance: Through the inclusion of HPA, I ensure that my application is equipped to handle varying workloads, maintaining high performance and efficient resource utilization.

- Quality Assurance Through Testing: By integrating testing into my Helm chart, I affirm my commitment to reliability, making sure that the application is not only deployable but also fully functional.

### Reflections on My Helm Chart
My Helm chart is not just a deployment tool; it is a testament to my understanding of Kubernetes best practices and my commitment to maintaining a robust, efficient, and secure application infrastructure. In its design, execution, and purpose, my Helm chart is a reflection of my expertise in Kubernetes management, serving as a guiding framework for sophisticated and future-ready application orchestration.

*While my Helm chart stands as a comprehensive and meticulously crafted blueprint for Kubernetes application management, it's important to acknowledge a crucial aspect that is yet to be integrated - the implementation of an external-secrets mechanism. This omission, albeit subtle, holds significant implications for the chart's full potential and readiness for deployment.

## The Impact of Omitting External-Secrets !!

1. Security Limitations: At its core, Kubernetes secrets are designed to store and manage sensitive information, such as passwords and tokens. However, without the integration of an external-secrets system, my chart relies on the basic Kubernetes secrets mechanism, which, while functional, lacks advanced security features. This could potentially expose sensitive data to risks, as Kubernetes secrets are not encrypted at rest by default.

2. Operational Efficiency: External-secrets systems like HashiCorp Vault or AWS Secrets Manager offer enhanced management features, including versioning and fine-grained access controls. By not utilizing such a system, my chart misses out on these efficiencies, potentially leading to more cumbersome secret management and updates.

3. Scalability Constraints: As the application scales, the need for a more robust secret management system becomes critical. The absence of an external-secrets system in my chart could limit its scalability, particularly in complex environments where the volume and sensitivity of secrets are higher.

4. Compliance Challenges: In environments that require strict compliance with data security standards, relying solely on Kubernetes secrets may not suffice. External-secrets systems often provide better compliance capabilities, such as audit trails and automatic rotation of secrets, which are essential for regulatory adherence.

### Conclusion - Not Yet Fully Primed for Deployment

In light of these considerations, it's clear that while my Helm chart is a robust and well-designed framework, it is not yet fully primed for deployment, especially in environments where advanced security, operational efficiency, scalability, and compliance are paramount. The integration of an external-secrets system is not just an enhancement; it's a critical step towards unlocking the full potential of my Helm chart, ensuring that it can securely and efficiently manage applications at scale and in compliance with stringent security standards.
## ArgoCD


## Graphs
