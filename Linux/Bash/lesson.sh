#! /usr/bin/env bash


read -p "Enter your first name: " fname
echo "Hello $fname!"

read -p "Enter your last name: " lname
echo "Hello $fname $lname!"

read -p "Enter your age: " age

read -p "Are you male or female? " gender

if [ $age -lt 21 and $gender = "male" ] ; then
    echo "You are not allowed to enter."

elif [ $age -lt 21 and $gender = "female" ]; then
    echo "You are allowed to enter, but you are not allowed to drink."

elif [ $age -ge 21 and $gender = "male" ]; then
    echo "You are allowed to enter and drink."

elif [ $age -ge 21 and $gender = "female" ]; then
    echo "You are allowed to enter and drink."

fi



