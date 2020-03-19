#!/bin/sh

# be an arbitrary program that is running as random user
while true; do
	# perform your work step
	echo work-by:$(id -u):$(id -g):$(pwd):$(date)\
		|tee -a $(pwd)/success
	# Enhance your Calm
    sleep 1

done
