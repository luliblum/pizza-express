#!/bin/bash

. .env

sudo docker exec -it pizza-express_app_1 npm test
if [[ $? != "0" ]]; then
	echo "error in test"
	exit 1
fi

sudo docker-compose build
if [[ $? != "0" ]]; then
	echo "error in build"
	exit 1
fi
sudo docker-compose down
sleep 5
sudo docker-compose up -d
if [[ $? != "0" ]]; then
	echo "error in up"
	exit 1
fi

sleep 5
response=$(curl --write-out %{http_code} --silent --output /dev/null http://localhost:8081)
if [[ $response != "200" ]]; then
	echo "error in curl"
	exit 1
fi

sudo docker rmi "$USERNAME/$IMAGE:latest"

if [[ $? != "0" ]]; then
	echo "error in rm image container"
	exit 1
fi

sudo docker tag "$USERNAME/$IMAGE:$VER" "$USERNAME/$IMAGE:latest"

if [[ $? != "0" ]]; then
	echo "error in giving tag"
	exit 1
fi
sleep 1

sudo docker login -u $USERNAME -p $PASSWORD 

sudo docker push "$USERNAME/$IMAGE:$VER"
if [[ $? != "0" ]]; then
	echo "error in push image"
	exit 1
fi

sleep 5

sudo docker push "$USERNAME/$IMAGE:latest"

if [[ $? != "0" ]]; then
	echo "error by pushing the latest name tag"
	exit 1
fi
sleep 2
