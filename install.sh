#!/bin/bash

for f in ./.*
do
	if [ $f != ".git" ]
	then

		ln -s $f ~/
		echo "linking to $f in your home-directory"
	fi
done
