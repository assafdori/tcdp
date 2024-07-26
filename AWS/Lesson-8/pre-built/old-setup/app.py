from flask import Flask, render_template, request
import mysql.connector
import os

app = Flask(__name__)

db_host = os.getenv('DB_HOST', 'localhost')
db_user = os.getenv('DB_USER', 'root')
db_password = os.getenv('DB_PASSWORD', 'password')

def get_db_connection(db_name=None):
    connection = mysql.connector.connect(
        host=db_host,
        user=db_user,
        password=db_password,
        database=db_name
    )
    return connection

@app.route('/')
def index():
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("SHOW DATABASES")
    databases = cursor.fetchall()
    cursor.close()
    connection.close()
    return render_template('index.html', databases=databases)

@app.route('/tables', methods=['POST'])
def tables():
    db_name = request.form['database']
    connection = get_db_connection(db_name)
    cursor = connection.cursor()
    cursor.execute("SHOW TABLES")
    tables = cursor.fetchall()
    cursor.close()
    connection.close()
    return render_template('tables.html', database=db_name, tables=tables)

@app.route('/content', methods=['POST'])
def content():
    db_name = request.form['database']
    table_name = request.form['table']
    connection = get_db_connection(db_name)
    cursor = connection.cursor()
    cursor.execute(f"SELECT * FROM {table_name}")
    rows = cursor.fetchall()
    columns = [desc[0] for desc in cursor.description]
    cursor.close()
    connection.close()
    return render_template('content.html', columns=columns, rows=rows)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
