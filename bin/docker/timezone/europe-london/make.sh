ZONE=europe-london
sudo docker build -t timezone-$ZONE . \
&& sudo docker run timezone-$ZONE \
&& sudo docker run -it timezone-$ZONE bash
