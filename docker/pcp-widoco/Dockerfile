FROM docker.io/ubuntu:22.04
MAINTAINER Thomas Riechert <thomas.riechert@htwk-leipzig.de>

RUN apt-get update

# Installieren von OpenJDK17, Git, raputils, openssh
RUN apt-get install -y openjdk-17-jre git raptor2-utils openssh-client vim

RUN mkdir /root/.ssh
WORKDIR /root/

# Kopieren Sie die JAR-Datei in das Arbeitsverzeichnis
COPY widoco-1.4.21-jar-with-dependencies_JDK-17.jar .

#Buildfile
COPY build.sh .

CMD ["bash", "build.sh"]

