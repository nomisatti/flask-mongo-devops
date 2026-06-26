from flask import Flask, jsonify, request, render_template, redirect, url_for, flash
from pymongo import MongoClient
from bson import ObjectId
from prometheus_flask_exporter import PrometheusMetrics
import os

app = Flask(__name__)
app.secret_key = "devops-flask-key"

metrics = PrometheusMetrics(app)
metrics.info("app_info", "Flask MongoDB DevOps App", version="1.0.0")

client = MongoClient(os.environ.get("MONGO_URI", "mongodb://mongo:27017/"))
db = client["flask_db"]

@app.route("/")
def home():
    users = list(db.users.find())
    return render_template("index.html", users=users)

@app.route("/add", methods=["POST"])
def add_user():
    name = request.form.get("name")
    email = request.form.get("email")

    if not name or not email:
        flash("Both name and email are required.", "error")
        return redirect(url_for("home"))

    existing = db.users.find_one({"email": email})
    if existing:
        flash(f"Email {email} already exists.", "error")
        return redirect(url_for("home"))

    db.users.insert_one({"name": name, "email": email})
    flash("User added successfully!", "success")
    return redirect(url_for("home"))

@app.route("/delete/<user_id>", methods=["POST"])
def delete_user(user_id):
    db.users.delete_one({"_id": ObjectId(user_id)})
    flash("User deleted successfully!", "success")
    return redirect(url_for("home"))

@app.route("/health")
def health():
    return jsonify({"status": "healthy"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)