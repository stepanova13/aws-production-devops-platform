
import os
import time

import psycopg2
from flask import Flask, jsonify

app = Flask(__name__)


def get_db_connection():
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        port=os.getenv("DB_PORT", "5432"),
        dbname=os.getenv("DB_NAME", "devopsdb"),
        user=os.getenv("DB_USER", "devopsuser"),
        password=os.getenv("DB_PASSWORD", "devopspassword"),
        connect_timeout=5,
    )


def initialize_database():
    for attempt in range(10):
        try:
            with get_db_connection() as conn:
                with conn.cursor() as cur:
                    cur.execute("""
                        CREATE TABLE IF NOT EXISTS visits (
                            id SERIAL PRIMARY KEY,
                            message TEXT NOT NULL,
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                        )
                    """)
            print("Database initialized successfully.")
            return
        except psycopg2.OperationalError:
            if attempt == 9:
                raise
            print("Waiting for PostgreSQL...")
            time.sleep(2)


@app.route("/")
def home():
    return jsonify(
        message="AWS DevOps Platform is running!",
        database="PostgreSQL configured"
    )


@app.route("/visits", methods=["POST"])
def create_visit():
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "INSERT INTO visits (message) VALUES (%s) RETURNING id",
                ("Hello from Flask!",)
            )
            visit_id = cur.fetchone()[0]

    return jsonify(id=visit_id, message="Visit saved"), 201


@app.route("/visits", methods=["GET"])
def get_visits():
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT id, message, created_at FROM visits ORDER BY id"
            )
            rows = cur.fetchall()

    return jsonify([
        {
            "id": row[0],
            "message": row[1],
            "created_at": row[2].isoformat()
        }
        for row in rows
    ])


if __name__ == "__main__":
    initialize_database()
    app.run(host="0.0.0.0", port=5000)
