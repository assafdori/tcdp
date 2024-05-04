#!/bin/bash

COUNTER=1
while [ $COUNTER -lt 11 ]; do
    echo "Counter: $COUNTER"
    COUNTER=$((COUNTER + 1))
done
