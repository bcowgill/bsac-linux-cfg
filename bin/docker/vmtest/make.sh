NAME=vmtest
VOLUME="--volume `pwd`/mountintovm:/mount/vmtest"
#VOLUME=

sudo docker build --build-arg greets="hola!" --tag $NAME . \
&& sudo docker run --rm $VOLUME $NAME \
&& sudo docker run --interactive --tty --rm $VOLUME --entrypoint bash $NAME

sudo docker images | grep $NAME
