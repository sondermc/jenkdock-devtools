FROM centos:centos7 as jenkdock-devtools
LABEL "vendor"="Geensnip"
LABEL authors="Chris Sondermeijer <chris.sondermeijer@gmail.com>"
ARG version=$version
LABEL version="$version"
LABEL description="Jenkins Build Agent, Centos7 including Developer tools and some lint syntax checkers. Can also be uses as a jenkins docker-template."
ARG BUILD_NUMBER=$BUILD_NUMBER
ARG BUILD_URL=$BUILD_URL
ARG JOB_NAME=$JOB_NAME
ARG GIT_COMMIT=$GIT_COMMIT
ARG GIT_URL=$GIT_URL
WORKDIR /var/cache/yum

ARG user=jenkins
ARG group=jenkins
ARG uid=10000
ARG gid=10000
ENV HOME /home/${user}
RUN groupadd -g ${gid} ${group}
RUN useradd -c "Jenkins user" -d $HOME -u ${uid} -g ${gid} -m ${user}
LABEL Description="This is a base image, which provides the Jenkins agent executable (slave.jar)" Vendor="Jenkins project" Version="3.9. Depends on the work of Oleg Nenashev https://hub.docker.com/r/jenkinsci/slave/"
ARG VERSION=3.9
ARG AGENT_WORKDIR=/home/${user}/agent
RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
 && chmod 755 /usr/share/jenkins \
 && chmod 644 /usr/share/jenkins/slave.jar
USER ${user}
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR}
VOLUME /home/${user}/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/${user}

RUN yum-config-manager --enable epel && \
  yum -y update && \
  yum -y groupinstall "Development Tools" && \
  yum -y install rpmlint ansible-lint python2-jsonschema pylint python-pep8 tree wget && \
  yum -y install java-1.8.0-openjdk-devel && \
  yum -y clean all && \
  rm -rf /var/cache/yum && \
  echo -e "BUILD_NUMBER=$BUILD_NUMBER \\nBUILD_URL=$BUILD_URL \\nJOB_NAME=$JOB_NAME \\nGIT_COMMIT=$GIT_COMMIT \\nGIT_URL=$GIT_URL \\n" > /root/dockerbuild.info
