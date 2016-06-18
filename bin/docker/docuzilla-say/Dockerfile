# Dockerfile
# docker build -t docuzilla-say ./
# docker run --hostname=zilla -it docuzilla-say
FROM docker/whalesay:latest
MAINTAINER Brent S.A. Cowgill
LABEL Description="This is the DocuZilla say image" Version="1.0"

RUN apt-get --yes update && apt-get install --yes fortunes && rm -rf /var/lib/apt/lists/*

# https://docs.docker.com/engine/userguide/containers/dockervolumes/#mount-a-host-directory-as-a-data-volume
# docker run --volume=/host/path:/dropzone docuzilla-say
# docker run --volume=/host/path:/dropzone:ro docuzilla-say  # read only mounted volume
RUN mkdir /dropzone
RUN echo "transfer directory between container and host system" > /dropzone/README.TXT
VOLUME /dropzone

CMD (perl -e '$d=`date`; $h=`hostname`; chomp $d; chomp $h; \
print qq{On $d from $h, the great and powerful DocuZilla says:\n\n}' ; \
/usr/games/fortune -a) | cowsay -f dragon

