ZONE=america-vancouver
NAME=timemachine-$ZONE
HUBNAME=zardozcs/$NAME

cp /home/me/workspace/play/timemachine/go.js .

if [ ! -z $1 ]; then
	# pushing the final build to docker hub if an image hash given
	sudo docker tag $1 $HUBNAME
	sudo docker login
	sudo docker push $HUBNAME
else
	sudo docker build -t $NAME . \
	&& sudo docker run --rm $NAME \
	&& sudo docker run -it --rm --entrypoint bash $NAME

	sudo docker images | grep $NAME
fi
