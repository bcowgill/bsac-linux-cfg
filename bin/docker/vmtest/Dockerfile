FROM node:latest

# specify build time argument and preserve it in an ENV variable
ARG greets
ENV greets=${greets:-hello!}
RUN echo greets=$greets
# value of ARG is overridden by build command as follows:
# docker build --build-arg greets="hola!" -t vmtest .

ENV AUTHOR="Brent S.A. Cowgill"
MAINTAINER $AUTHOR
LABEL Version="1.0" \
	Description="This image is a test of Dockerfile instructions"
# ONBUILD does not immediately affect this build, but any which are configured FROM this image.
ONBUILD RUN echo "This image was built from the vmtest image by Brent S.A. Cowgill"
# docker inspect [imagename] will show the above info in an image

# https://docs.docker.com/engine/reference/builder/

USER root
ENV PACKAGES=vim
ENV VOLUME=/mount/vmtest
WORKDIR /vmtest

RUN echo SHELL=$SHELL
SHELL [ "/bin/bash", "-c" ]
RUN echo SHELL=$SHELL

RUN apt-get --yes update \
	&& apt-get install --yes $PACKAGES \
	&& rm -rf /var/lib/apt/lists/*

COPY readme.txt .
ADD https://docs.docker.com/index.html docs.docker.html

EXPOSE 80

RUN mkdir -p $VOLUME
RUN echo "If you can see this you didn't provide a volume mount with your docker run command. docker run --volume /host/os/path:$VOLUME ..." > $VOLUME/README.TXT
RUN echo "$greets this text will appear in the vm container at $VOLUME/greeting....txt but will be hidden by the VOLUME mount at run time if given." > $VOLUME/greeting_stuck_in_the_vm.txt
#VOLUME [ "/mount/vmtest" ]
VOLUME $VOLUME
# To connect a host system path to the mounted volume:
# docker run --volume `pwd`/hostdir:/mount/vmtest vmtest
# docker run --volume `pwd`/hostdir:/mount/vmtest:ro vmtest  # read only

STOPSIGNAL SIGKILL
HEALTHCHECK --interval=5m --timeout=3s --retries=3 \
	CMD ls || exit 1

# "sudo docker run vmtest" will execute "ls -1"
# but "sudo docker run vmtest -al" will ignore the CMD args and run "ls -al"
# and "sudo docker run --entrypoint ps vmtest aux" will bypass both and run "ps aux"
# this non-shell form of ENTRYPOINT/CMD will allow signals from docker to pass through to the container
# i.e. docker stop container_name will work
#ENTRYPOINT [ "ls" ]
#CMD [ "-1", "/" ]

# this shell version ENTRYPOINT using exec will perform shell processing and pass signals to the top command so docker stop will work
#ENTRYPOINT exec top -b
#CMD [ "-c" ]

#CMD [ "head", "readme.txt", "docs.docker.html" ]

#CMD echo "only CMD lines can write out to the HOST OS mounted VOLUME." > /mount/vmtest/greeting_from_vm_to_host_os.txt; ls /mount/vmtest
