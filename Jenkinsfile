pipeline {
    agent {
        kubernetes {
            label 'jenkins-agent'
            defaultContainer 'jnlp'  // Use the default Jenkins container
            yaml """
            apiVersion: v1
            kind: Pod
            spec:
              containers:
              - name: jnlp
                image: jenkins/inbound-agent
                args: ['\$(JENKINS_SECRET)', '\$(JENKINS_NAME)']
                tty: true
                resources:
                  requests:
                    memory: "512Mi"
                    cpu: "500m"
                  limits:
                    memory: "1024Mi"
                    cpu: "1"
              volumes:
              - name: docker-socket
                hostPath:
                  path: /var/run/docker.sock
                  type: File
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
