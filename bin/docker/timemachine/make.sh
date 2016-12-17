ZONE=america-vancouver
cp /home/me/workspace/play/timemachine/go.js .
sudo docker build -t timemachine-$ZONE . \
&& sudo docker run timemachine-$ZONE \
&& sudo docker run -it timemachine-$ZONE bash
# pushing the final build to docker hub
sudo docker images | grep timemachine-$ZONE
# sudo docker tag [IMAGE ID] zardozcs/timemachine-$ZONE
# sudo docker login
# sudo docker push [IMAGE ID]
