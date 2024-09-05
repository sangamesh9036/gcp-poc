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
                image: jenkins/inbound-agent
                args: ['\$(JENKINS_SECRET)', '\$(JENKINS_NAME)']
                tty: true
            """
        }
    }
    environment {
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'
        REGISTRY_URL = 'https://index.docker.io/v1/'
        DOCKER_IMAGE = 'my-app:${env.BUILD_ID}'
        KUBECONFIG_CREDENTIALS_ID = 'kubeconfig'
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
                    docker.build(DOCKER_IMAGE).push()
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
