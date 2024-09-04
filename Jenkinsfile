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
                image: devsanga/jenkins-agent-with-docker:latest
                tty: true
            """
        }
    }
    environment {
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'
        REGISTRY_URL = 'https://index.docker.io/v1/'
        KUBECONFIG_CREDENTIALS_ID = 'kubeconfig'
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/sangamesh9036/gcp-poc.git', credentialsId: 'github-pat-credentials'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    def imageTag = "build-${env.BUILD_ID}".toLowerCase().replaceAll("[^a-z0-9-]", "")
                    def customImage = docker.build("devsanga/my-app:${imageTag}")
                    customImage.push()
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
