PROVE=${1:-}
NODES="0.10.0 1.0.0 2.0.0 3.0.0 4.0.0 5.0.0 6.0.0 7.0.0 8.0.0 9.0.0 10.0.0"
for node in $NODES; do
	echo '#!/bin/bash' > ./test-n-$node.sh
	echo ./tests.sh $node >> ./test-n-$node.sh
	chmod +x ./test-n-$node.sh
	$PROVE ./test-n-$node.sh
	rm ./test-n-$node.sh
done
