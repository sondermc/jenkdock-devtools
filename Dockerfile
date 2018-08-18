FROM centos:centos7 as jenkins-devtools
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

RUN yum-config-manager --enable epel && \
  yum -y update && \
  yum -y groupinstall "Development Tools" && \
  yum -y install rpmlint ansible-lint python2-jsonschema pylint python-pep8 tree wget && \
  yum -y install java-1.8.0-openjdk-devel && \
  yum -y clean all && \
  rm -rf /var/cache/yum && \
  echo -e "BUILD_NUMBER=$BUILD_NUMBER \\nBUILD_URL=$BUILD_URL \\nJOB_NAME=$JOB_NAME \\nGIT_COMMIT=$GIT_COMMIT \\nGIT_URL=$GIT_URL \\n" > /root/dockerbuild.info
