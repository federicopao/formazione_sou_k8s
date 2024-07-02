FROM jenkins/jenkins

USER root

RUN apt-get update && apt-get install -y docker.io && rm -rf /var/lib/apt/lists/*
RUN usermod -aG docker jenkins

USER jenkins

# COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
# COPY jenkins-configuration.yaml /var/jenkins_home/jenkins-configuration.yaml

# ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
# ENV CASC_JENKINS_CONFIG /var/jenkins_home/jenkins-configuration.yaml
# RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt
