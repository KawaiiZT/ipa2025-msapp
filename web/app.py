import os
from flask import Flask, request, render_template, redirect, url_for
from pymongo import MongoClient
from bson import ObjectId

app = Flask(__name__)

db_name = os.environ.get("DB_NAME")

client = MongoClient("mongodb://mongo:27017/")
db = client["ipa2025_db"]
routers = db["routers"]

@app.route("/")
def index():
    data = []
    for x in routers.find():
        data.append(x)
    return render_template("index.html", routers=data)

@app.route("/add", methods=["POST"])
def add_router():
    ip = request.form.get("ip")
    username = request.form.get("username")
    password = request.form.get("password")
    if ip and username and password:
        routers.insert_one(
            {
                "ip": ip,
                "username": username,
                "password": password
            }
        )
    return redirect("/")

@app.route("/delete/<id>", methods=["POST"])
def delete_router(id):
    routers.delete_one({"_id": ObjectId(id)})
    return redirect("/")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
