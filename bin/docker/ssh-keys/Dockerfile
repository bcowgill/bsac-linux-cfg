# Dockerfile
# docker build -t ssh-keys ./
# mkdir ./keys
# docker run --hostname=docker-ssh-keys --volume=$(pwd)/keys:/dropzone -it ssh-keys
FROM ubuntu:latest
MAINTAINER Brent S.A. Cowgill
LABEL Description="This image is for creating ssh-keys" Version="1.0"

RUN apt-get --yes update && apt-get --yes install ssh && rm -rf /var/lib/apt/lists/*

# https://docs.docker.com/engine/userguide/containers/dockervolumes/#mount-a-host-directory-as-a-data-volume
RUN mkdir /dropzone
RUN echo "transfer directory between container and host system" > /dropzone/README.TXT
RUN perl -e 'print "\n"' | ssh-keygen -t rsa -C "ssh keys for docker access to git repositories"
RUN cat root/.ssh/id_rsa.pub
VOLUME /dropzone
COPY keys/from-host.txt root/
RUN cat root/from-host.txt
CMD bash
