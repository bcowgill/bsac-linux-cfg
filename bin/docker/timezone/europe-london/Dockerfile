FROM ubuntu:latest

MAINTAINER Brent S.A. Cowgill
LABEL Description="This image runs ubuntu with timezone set to Europe/London" Version="1.0"

ENV TZ=Europe/London
RUN perl -e 'print qq{8\n27\n}' | dpkg-reconfigure tzdata

CMD echo TZ=$TZ; /bin/date
