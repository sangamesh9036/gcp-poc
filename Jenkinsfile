pipeline {
    agent {
        kubernetes {
            label 'docker-agent'
            defaultContainer 'docker'
            yaml """
            apiVersion: v1
            kind: Pod
            spec:
              containers:
              - name: docker
                image: docker:20.10.24
                command:
                - cat
                tty: true
                volumeMounts:
                - name: docker-sock
                  mountPath: /var/run/docker.sock
              - name: kubectl
                image: lachlanevenson/k8s-kubectl:v1.21.0
                command:
                - cat
                tty: true
              volumes:
              - name: docker-sock
                hostPath:
                  path: /var/run/docker.sock
            """
        }
    }
    environment {
        DOCKER_IMAGE = "devsanga/test-image:${env.BUILD_NUMBER}"
        K8S_DEPLOYMENT_FILE = "k8s-deployment.yaml"  // Assuming this is already present in the repo
    }
    stages {
    stages {
        stage('Install Git') {
            steps {
                container('docker') {
                    script {
                        sh '''
                        # Install Git inside the Docker container
                        apk add --no-cache git
                        '''
                    }
                }
            }
        }        
        stage('Clean Workspace') {
            steps {
                container('docker') {
                    script {
                        deleteDir() // Clean the workspace to avoid conflicts
                    }
                }
            }
        }
        stage('Clone Git Repository') {
            steps {
                container('docker') {
                    script {
                        withCredentials([string(credentialsId: 'github-credentials', variable: 'GIT_TOKEN')]) {
                            sh '''
                            # Configure safe directory for Git
                            git config --global --add safe.directory /home/jenkins/agent/workspace/K8s-Deployment-Pipeline

                            # Clone the GitHub repository containing the application code and k8s-deployment.yaml
                            git clone https://$GIT_TOKEN@github.com/sangamesh9036/gcp-poc.git .
                            git checkout unnecessary
                            '''
                        }
                    }
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                container('docker') {
                    script {
                        sh '''
                        # Build the Docker image using the Dockerfile from the cloned repo
                        docker build -t ${DOCKER_IMAGE} .

                        # List Docker images to verify the build
                        docker images
                        '''
                    }
                }
            }
        }
        stage('Push Docker Image to Docker Hub') {
            steps {
                container('docker') {
                    script {
                        withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                            sh '''
                            # Log in to Docker Hub using the credentials
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

                            # Push the Docker image to Docker Hub
                            docker push ${DOCKER_IMAGE}

                            # Log out from Docker Hub for security reasons
                            docker logout
                            '''
                        }
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                container('kubectl') {
                    script {
                        sh '''
                        # Update the deployment file to use the newly built Docker image
                        sed -i 's|image: docker.io/devsanga/my-app:latest|image: ${DOCKER_IMAGE}|g' ${K8S_DEPLOYMENT_FILE}

                        # Ensure the namespace exists (if not already created)
                        kubectl create namespace my-app-namespace --dry-run=client -o yaml | kubectl apply -f -

                        # Apply the updated deployment YAML to the Kubernetes cluster
                        kubectl apply -f ${K8S_DEPLOYMENT_FILE}
                        '''
                    }
                }
            }
        }
    }
}
