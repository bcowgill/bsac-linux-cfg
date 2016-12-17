ZONE=europe-london
sudo docker build -t timezone-$ZONE . \
&& sudo docker run timezone-$ZONE \
&& sudo docker run -it timezone-$ZONE bash

# pushing the final build to docker hub
sudo docker images | grep timezone-$ZONE
# sudo docker tag [IMAGE ID] zardozcs/timezone-$ZONE
# sudo docker login
# sudo docker push [IMAGE ID]
