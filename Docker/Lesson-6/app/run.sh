# Write a Bash Script for building and running the Docker Container

docker build -t flask-app .
docker run -p 5001:5001 --name flask-app flask-app
