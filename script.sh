#!/bin/bash

. .env
docker-compose up -d
sleep 4 
docker exec -it pizza-express_app_1 npm test
if [[ $? != "0" ]]; then
	echo "error in test"
	exit 1
fi

docker-compose build
if [[ $? != "0" ]]; then
	echo "error in build"
	exit 1
fi

docker tag "$USERNAME/$IMAGE:$VER" "$USERNAME/$IMAGE:latest"

if [[ $? != "0" ]]; then
	echo "error in giving tag"
	exit 1
fi
sleep 1

docker-compose down
sleep 5
docker-compose up -d
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

# docker rmi "$USERNAME/$IMAGE:latest"

#if [[ $? != "0" ]]; then
#	echo "error in rm image container"
#	exit 1
#fi

docker login -u $USERNAME -p $PASSWORD 

docker push "$USERNAME/$IMAGE:$VER"
if [[ $? != "0" ]]; then
	echo "error in push image"
	exit 1
fi

sleep 5

docker push "$USERNAME/$IMAGE:latest"

if [[ $? != "0" ]]; then
	echo "error by pushing the latest name tag"
	exit 1
fi
sleep 2
