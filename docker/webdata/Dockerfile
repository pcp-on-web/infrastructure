FROM docker.io/ubuntu:22.04
MAINTAINER Thomas Riechert <thomas.riechert@htwk-leipzig.de>

RUN apt-get update

RUN apt-get install -y git openssh-client vim wget unzip

RUN mkdir /data && mkdir /root/.ssh

#Buildfile
COPY build.sh .

CMD ["bash", "build.sh"]
