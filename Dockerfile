FROM jenkins/jenkins:lts

# Switch to root to install packages and configure sudo
USER root

# Install Docker and basic utilities
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg-agent \
    software-properties-common sudo vim nano dnsutils iputils-ping telnet \
    net-tools && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io

# Set password for the Jenkins user (corrected)
RUN echo "jenkins:SignOfUnity@22" | chpasswd

# Add Jenkins to Docker group and configure passwordless sudo (optional)
RUN usermod -aG docker jenkins && \
    echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Switch back to Jenkins user
USER jenkins

# Expose Jenkins and Docker ports
EXPOSE 8080 50000
