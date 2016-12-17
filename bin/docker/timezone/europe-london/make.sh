ZONE=europe-london
NAME=timezone-$ZONE
HUBNAME=zardozcs/$NAME

sudo docker build -t $NAME . \
&& sudo docker run $NAME \
&& sudo docker run -it $NAME bash

# pushing the final build to docker hub if an image hash given
sudo docker images | grep $NAME
if [ ! -z $1 ]; then
	sudo docker tag $1 $HUBNAME
	sudo docker login
	sudo docker push $HUBNAME
fi
