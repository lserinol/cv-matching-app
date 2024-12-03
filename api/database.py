import sqlite3
from datetime import datetime

def initialize_db():
    conn = sqlite3.connect('cv.db')
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS cv (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fileName TEXT NOT NULL,
            downloadURL TEXT NOT NULL,
            uploadedAt TEXT NOT NULL,
            extractedInfo TEXT
        )
    ''')
    conn.commit()
    conn.close()

def insert_cv(fileName, downloadURL, uploadedAt, extractedInfo):
    conn = sqlite3.connect('cv.db')
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO cv (fileName, downloadURL, uploadedAt, extractedInfo)
        VALUES (?, ?, ?, ?)
    ''', (fileName, downloadURL, uploadedAt, extractedInfo))
    conn.commit()
    conn.close()

def get_cvs():
    conn = sqlite3.connect('cv.db')
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM cv')
    rows = cursor.fetchall()
    conn.close()
    return rows
