from flask import Flask, render_template, request, redirect
import mysql.connector
import psycopg2
import os

app = Flask(__name__)

DATABASE_URL = os.environ.get("postgresql://bloodbank_db_vvfz_user:iWcwElXQppdW50j2khuEEFliXNMhcv8p@dpg-d2liq4n5r7bs73dp5smg-a/bloodbank_db_vvfz")

conn = psycopg2.connect(DATABASE_URL)
cursor = conn.cursor()

def get_connection():
    return mysql.connector.connect(
        host='localhost',
        user='root',
        password='cse@123',
        database='bloodbank'
    )

@app.route('/')
def index():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM donors")
    donors = cursor.fetchall()

    cursor.execute("SELECT * FROM recipients")
    recipients = cursor.fetchall()

    cursor.execute("SELECT * FROM blood_stock")
    stock = cursor.fetchall()

    cursor.close()

    return render_template('index.html', donors=donors, recipients=recipients, stock=stock)

@app.route('/add_donor', methods=['POST'])
def add_donor():
    name = request.form['name']
    age = request.form['age']
    gender = request.form['gender']
    blood_type = request.form['blood_type']
    donation_date = request.form['donation_date']
    units_donated = request.form['units_donated']

    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO donors (name, age, gender, blood_type, donation_date, units_donated)
        VALUES (%s, %s, %s, %s, %s, %s)
    """, (name, age, gender, blood_type, donation_date, units_donated))
    conn.commit()
    cursor.close()
    return redirect('/')

@app.route('/check_blood', methods=['POST'])
def check_blood():
    blood_type = request.form['blood_type']
    units_requested = int(request.form['units_requested'])

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT units_available FROM blood_stock WHERE blood_type = %s", (blood_type,))
    result = cursor.fetchone()
    cursor.close()

    available = result and result['units_available'] >= units_requested

    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM donors")
    donors = cursor.fetchall()
    cursor.execute("SELECT * FROM recipients")
    recipients = cursor.fetchall()
    cursor.execute("SELECT * FROM blood_stock")
    stock = cursor.fetchall()
    cursor.close()

    return render_template('index.html', donors=donors, recipients=recipients, stock=stock,
                           check_result=available, checked_blood=blood_type, requested_units=units_requested)

@app.route('/book_blood', methods=['POST'])
def book_blood():
    name = request.form['name']
    age = request.form['age']
    gender = request.form['gender']
    blood_type = request.form['blood_type']
    received_date = request.form['received_date']
    units_received = request.form['units_received']

    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO recipients (name, age, gender, blood_type, received_date, units_received)
        VALUES (%s, %s, %s, %s, %s, %s)
    """, (name, age, gender, blood_type, received_date, units_received))
    conn.commit()
    cursor.close()
    return redirect('/')

if __name__ == '__main__':
    app.run(debug=True, host="127.0.0.1", port=5000)
