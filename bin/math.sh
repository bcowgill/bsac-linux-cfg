#!/bin/bash

SAMPLES=~/bin/character-samples
TEMPL=~/bin/template

SYM=$SAMPLES/symbols-math-other.txt
MATH=$SAMPLES/samples/mathematics.txt
MATHC=$SAMPLES/samples/mathematics-categorised.txt
EQN=$TEMPL/text/equations-that-changed-the-world.txt

if [ "$1" == "--eqn" ]; then
	vim $EQN
	exit
fi
if [ "$1" == "--sym" ]; then
	vim $SYM
	exit
fi
if [ "$1" == "--math" ]; then
	vim $MATH
	exit
fi
if [ "$1" == "--cat" ]; then
	vim $MATHC
	exit
fi
if [ -z "$1" ]; then
	vim $SYM $MATH $EQN $MATHC
	exit
else
	echo "option $1 unknown"
fi
