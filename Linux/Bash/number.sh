#! /bin/bash
echo "Please enter a number between 1-10"
read number

if [ $((number % 2)) -eq 0 ]; then
    echo "$number is even."

else
    echo "$number is odd."

fi