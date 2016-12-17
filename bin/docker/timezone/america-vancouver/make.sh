ZONE=america-vancouver
NAME=timezone-$ZONE
HUBNAME=zardozcs/$NAME

if [ ! -z $1 ]; then
	# pushing the final build to docker hub if an image hash given
	sudo docker tag $1 $HUBNAME
	sudo docker login
	sudo docker push $HUBNAME
else
	sudo docker build -t $NAME . \
	&& sudo docker run $NAME \
	&& sudo docker run -it $NAME bash

	sudo docker images | grep $NAME
fi
