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
sleep 5

if [[ $? != "0" ]]; then
	echo "error in up"
	exit 1
fi
response=$(curl --write-out %{http_code} --silent --output /dev/null http://localhost:8081)
if [[ $response != "200" ]]; then
	echo "error in curl"
	exit 1
fi

sudo docker rmi "$USERNAME/$IMAGE:latest"
sudo docker tag "$USERNAME/$IMAGE:$VER" "$USERNAME/$IMAGE:latest"
sudo docker push "$USERNAME/$IMAGE:$VER"
sudo docker push "$USERNAME/$IMAGE:latest"
