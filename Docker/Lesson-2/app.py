# This is a random python app

from flask import Flask
import socket

app = Flask(__name__)

@app.route('/')
def index():
    container_ip = socket.gethostbyname(socket.gethostname())
    return f"Container IP Address: {container_ip}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5050)
