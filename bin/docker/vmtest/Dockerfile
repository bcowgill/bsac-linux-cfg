FROM node:latest

MAINTAINER Brent S.A. Cowgill
LABEL Version="1.0" \
	Description="This image is a test of Dockerfile instructions"

# https://docs.docker.com/engine/reference/builder/

ENV PACKAGES=vim

RUN apt-get --yes update \
	&& apt-get install --yes $PACKAGES \
	&& rm -rf /var/lib/apt/lists/*

COPY readme.txt .
ADD https://docs.docker.com/index.html docs.docker.html

EXPOSE 80

# "sudo docker run vmtest" will execute "ls -1"
# but "sudo docker run vmtest -al" will ignore the CMD args and run "ls -al"
# and "sudo docker run --entrypoint ps vmtest aux" will bypass both and run "ps aux"
# this non-shell form of ENTRYPOINT/CMD will allow signals from docker to pass through to the container
# i.e. docker stop container_name will work
ENTRYPOINT [ "ls" ]
CMD [ "-1" ]

#CMD [ "head", "readme.txt", "docs.docker.html" ]
