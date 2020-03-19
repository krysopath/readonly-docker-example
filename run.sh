#!/bin/sh
while true; do
	echo work-by:$(id -u):$(id -g):$(PWD):$(date)\
		|tee -a $PWD/success
    sleep 1

done
