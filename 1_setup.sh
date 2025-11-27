# Setup the docker container, and enter into the container
docker compose -f docker-compose.yml up --build -d
docker exec -it fingerprinting bash