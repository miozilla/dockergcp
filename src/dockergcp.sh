#!/bin/bash
# Build the image and tag it with 0.2
docker build -t node-app:0.2 .

# Debug
docker logs -f [container_id]
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' [container_id]

# Publish/Push image to the Google Artifact Registry

# Configure authentication
gcloud auth configure-docker "REGION"-docker.pkg.dev

# Create an Artifact Registry repository
gcloud artifacts repositories create my-repository --repository-format=docker --location="REGION" --description="Docker repository"

# Run the command to tag node-app:0.2
docker build -t "REGION"-docker.pkg.dev/"PROJECT_ID"/my-repository/node-app:0.2 .

# Push the image to Artifact Registry
docker push "REGION"-docker.pkg.dev/"PROJECT_ID"/my-repository/node-app:0.2

# Test the image

# Run the command to remove all of the Docker images.
docker rmi -f $(docker images -aq) # remove remaining images

# Pull the image and run it
docker run -p 4000:80 -d "REGION"-docker.pkg.dev/"PROJECT_ID"/my-repository/node-app:0.2

# Run a curl against the running container.
curl http://localhost:4000
