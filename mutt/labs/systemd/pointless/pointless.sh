#!/bin/bash

echo "My PID is: $$"
while true; do
    echo "The current time is $(date)"
    echo "JAVA_HOME=$JAVA_HOME"
    echo "GOPATH=$GOPATH"
    sleep 10
done
