pipeline {
    agent {
        kubernetes {
            label 'kubeagent'
            defaultContainer 'jnlp'
        }
    }
    environment {
        DOCKER_IMAGE = "devsanga/test-image:${env.BUILD_NUMBER}"
    }
    stages {
        stage('Clone Git Repository') {
            steps {
                container('jnlp') {
                    script {
                        withCredentials([string(credentialsId: 'github-credentials', variable: 'GIT_TOKEN')]) {
                            sh '''
                            # Clone the Git repository using the GitHub token
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
                container('jnlp') {
                    script {
                        sh '''
                        # Check if Docker is installed and working
                        docker --version

                        # Build the Docker image using the Dockerfile from the cloned repo
                        docker build -t ${DOCKER_IMAGE} .

                        # List Docker images to verify the build
                        docker images
                        '''
                    }
                }
            }
        }
    }
}
