#!/bin/bash

# check for docker command
command -v docker &> /dev/null 2>&1 || { echo "Docker does not seem to be installed"; exit 1; }

domain_name=$1

if [ ! $domain_name ]
then
  echo "Missing domain"
  exit 1
fi

echo "Generating certificate for ${domain_name}"
# Създаваме golang image, който да използваме след това
echo "Building image for mkcert"
docker build -t mkcert-builder:latest . -f ./Dockerfile || { echo echo "Docker build for mkcert-builder:latest failed. Exiting." ; exit 2; }
echo "Image built"

echo "Trying to generate certificate for ${domain_name} inside the container"
docker run --rm -it --mount type=bind,source="$(pwd)"/output/,target=/usr/src/app/mkcert/output/ mkcert-builder:latest "${domain_name}"