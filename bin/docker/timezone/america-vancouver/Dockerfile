FROM ubuntu:latest

MAINTAINER Brent S.A. Cowgill
LABEL Description="This image runs ubuntu with timezone set to America/Vancouver" Version="1.0"

ENV TZ=America/Vancouver
RUN perl -e 'print qq{2\n149\n}' | dpkg-reconfigure tzdata

CMD echo TZ=$TZ; /bin/date
