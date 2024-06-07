from flask import Flask
import redis

app = Flask(__name__)
redis_client = redis.Redis(host='redis', port=6379)

@app.route('/')
def index():
    count = redis_client.incr('visits')
    return f'This page has been visited {count} times.'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)
