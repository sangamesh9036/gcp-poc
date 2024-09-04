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
        KUBECONFIG_CREDENTIALS_ID = 'kubeconfig'
    }
    stages {
        stage('Clone Repository') {
            steps {
@@ -10,11 +29,21 @@ pipeline {
            steps {
                script {
                    def imageTag = "build-${env.BUILD_ID}".toLowerCase().replaceAll("[^a-z0-9-]", "")
                    echo "Building Docker Image with tag: ${imageTag}"
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
