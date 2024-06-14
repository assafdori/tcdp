from flask import Flask, jsonify
import requests

app = Flask(__name__)

@app.route('/')
def joke():
    response = requests.get('https://api.chucknorris.io/jokes/random')
    joke = response.json().get('value')
    return jsonify(joke=joke)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5050)
