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
                image: devsanga/jenkins-docker_new:latest  // custom Jenkins agent image
                args: ['\$(JENKINS_SECRET)', '\$(JENKINS_NAME)']
                tty: true
                volumeMounts:
                - name: docker-socket
                  mountPath: /var/run/docker.sock
              volumes:
              - name: docker-socket
                hostPath:
                  path: /var/run/docker.sock
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
