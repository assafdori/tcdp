#!/bin/bash

URL="http://localhost:5050"

joke=$(curl -s $URL | jq -r '.joke')

words=$(echo $joke | wc -w)

printf "This Chuck Norris joke has: $words words! It reads: \n$joke"
