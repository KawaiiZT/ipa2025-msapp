#!/bin/bash

mkdir tempdir
mkdir tempdir/templates
mkdir tempdir/static

cp app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

echo "FROM python:3.10-slim" > tempdir/Dockerfile
echo "RUN pip install --no-cache-dir --progress-bar off flask" >> tempdir/Dockerfile
echo "RUN pip install --no-cache-dir --progress-bar off pymongo" >> tempdir/Dockerfile
echo "COPY  ./static /home/myapp/static/" >> tempdir/Dockerfile
echo "COPY  ./templates /home/myapp/templates/" >> tempdir/Dockerfile
echo "COPY  app.py /home/myapp/" >> tempdir/Dockerfile
echo "EXPOSE 8080" >> tempdir/Dockerfile
echo "CMD python /home/myapp/app.py" >> tempdir/Dockerfile

cd tempdir
docker build -t web .
docker run -d -p 27017:27017 --network app-net -v mongo-data:/data/db --name mongo mongo:6
docker run -d -p 8080:8080 --network app-net --name web web
docker ps -a 
