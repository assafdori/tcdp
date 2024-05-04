#!/bin/bash


# aux.sh
# Author: [your name here]
# Date: [date]
# Description: [description]


Cont="Y"
while [ $Cont = "Y" ]; do
    ps -A
    read -p "Do you want to continue? Y/N " reply Cont=$(echo $reply | tr [:upper:] [:lower:])
    echo $Cont
done


