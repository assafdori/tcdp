#!/bin/bash

docker build -t flask-app .

docker run -p 5001:5001 --name flask-app flask-app
