#!/bin/bash

while true; do
    curl http://localhost:18000/greet
    sleep 3
    echo "========================================"
done
