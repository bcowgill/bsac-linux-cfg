ZONE=america-vancouver
cp /home/me/workspace/play/timemachine/go.js .
sudo docker build -t timemachine-$ZONE . \
&& sudo docker run timemachine-$ZONE \
&& sudo docker run -it timemachine-$ZONE bash
