NAME=vmtest

sudo docker build -t $NAME . \
&& sudo docker run --rm $NAME \
&& sudo docker run -it --rm --entrypoint bash $NAME

sudo docker images | grep $NAME
