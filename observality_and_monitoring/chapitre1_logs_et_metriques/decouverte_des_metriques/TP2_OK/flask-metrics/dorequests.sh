#!/bin/sh


while true
        do
                curl -X POST  "http://localhost:5000/articles"
	 	current_datetime=$(date +"%Y-%m-%d %H:%M:%S")
		echo "\n $current_datetime: Waiting 5s before next send"
                sleep 5
        done
