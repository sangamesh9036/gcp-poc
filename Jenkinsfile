pipeline {
    agent {
        kubernetes {
            label 'jenkins-agent'
            yaml """
            apiVersion: v1
            kind: Pod
            spec:
              containers:
              - name: jenkins-agent
                image: ubuntu  // Change the image to something like 'ubuntu' or 'busybox'
                command:
                - cat
                tty: true
            """
        }
    }
    environment {
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'  // Docker Hub credentials
        REGISTRY_URL = 'https://index.docker.io/v1/'
        DOCKER_IMAGE = 'devsanga/my-app:${env.BUILD_ID}'  // Application Docker image
        KUBECONFIG_CREDENTIALS_ID = 'kubeconfig'          // Kubernetes Kubeconfig credentials ID
    }

    stages {
        stage('Test') {
            steps {
                echo 'Testing the pod with a different image...'
            }
        }
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/sangamesh9036/gcp-poc.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.withRegistry("${REGISTRY_URL}", "${DOCKER_CREDENTIALS_ID}") {
                        def app = docker.build("${DOCKER_IMAGE}")
                        app.push()  // Push the image with build ID tag
                        app.push('latest')  // Also push with the 'latest' tag
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    kubernetesDeploy(
                        configs: 'k8s-deployment.yaml',
                        kubeconfigId: KUBECONFIG_CREDENTIALS_ID,
                        enableConfigSubstitution: true
                    )
                }
            }
        }
    }
}
