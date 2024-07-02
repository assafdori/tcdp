from flask import Flask, render_template, request
import requests
import json

app = Flask(__name__)

def get_vehicle_info(mispar_rechev):
    url = "https://data.gov.il/api/3/action/datastore_search"
    params = {
        "resource_id": "053cea08-09bc-40ec-8f7a-156f0677aff3",
        "filters": json.dumps({"mispar_rechev": str(mispar_rechev)}),
        "limit": 1
    }
    response = requests.get(url, params=params)
    if response.status_code == 200:
        data = response.json()
        if data["success"] and data["result"]["records"]:
            return data["result"]["records"][0]
        else:
            return "No vehicle found with the given license plate number."
    else:
        return f"Error: {response.status_code}"

@app.route('/', methods=['GET', 'POST'])
def index():
    result = None
    if request.method == 'POST':
        mispar_rechev = request.form['mispar_rechev']
        if mispar_rechev.isdigit():
            result = get_vehicle_info(mispar_rechev)
        else:
            result = "Please enter a valid number for the license plate."
    return render_template('index.html', result=result)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5050)

