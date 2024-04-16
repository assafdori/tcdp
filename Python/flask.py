from flask import Flask
import requests

app = Flask('my-web-app')


@app.route('/')
def welcome():
    return 'Welcome to my Flask application.'

@app.route('/username')
def username():
    try:
        res = requests.get('https://randomuser.me/api/')
        userDict = res.json()

        userName = userDict['results'][0]['name']['first']

        return f'Hello {userName}.'
    
    except Exception as e:
        return f"An error occurred: {e}"
    
@app.route('/myip')
def myip():
    try:
        fetchip = requests.get('https://api.ipify.org/?format=json')
        myip    = fetchip.json()

        finalip = myip['ip']

        return f'Your IP address is: {finalip}'
    
    except Exception as e:
        return f"An error occurred: {e}"
    

@app.route('/whereami')
def location():
    try:
        location    = requests.get('https://ipapi.co/8.8.8.8/json/')
        mylocation  = location.json()

        finallocation = mylocation["city"]
        print('finallocation')
        print('mylocation')

        return f'Your location is: {finallocation}'
    
    except Exception as e:
        return f"An error occurred: {e}"
    

@app.route('/time')
def check_time():
    try:
        get_time     = requests.get('http://worldtimeapi.org/api/timezone/Asia/Jerusalem')
        my_time      = get_time.json()

        finaltime = my_time['datetime']

        return f'The time is: {finaltime}'
    
    except Exception as e:
        return f"An error occurred: {e}"
    

@app.route('/date')
def check_date():
    try:
        get_date     = requests.get('http://worldtimeapi.org/api/timezone/Asia/Jerusalem')
        my_date     = get_date.json()

        finaldate = my_date['utc_datetime']

        return f'The date is: {finaldate}'
    
    except Exception as e:
        return f"An error occurred: {e}"




if __name__ == '__main__':
    app.run(port=8000, debug=True)
