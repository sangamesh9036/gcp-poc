pipeline {
    agent any
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
                    echo "Building Docker Image with tag: ${imageTag}"
                    def customImage = docker.build("devsanga/my-app:${imageTag}")
                    customImage.push()
                }
            }
        }
    }
}
