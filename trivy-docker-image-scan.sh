#!/bin/bash

dockerImageName=$(awk 'NR==1 {print $2}' Dockerfile)
echo $dockerImageName

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /tmp/trivy:/root/.cache/ aquasec/trivy:0.31.3 -q --severity HIGH --exit-code 0 image $dockerImageName
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /tmp/trivy:/root/.cache/ aquasec/trivy:0.31.3 -q --severity CRITICAL --exit-code 1 image $dockerImageName

exit_code=$?
echo "Exit Code: $exit_code"

if [[ "$exit_code" == 1 ]]; then
    echo "Image scanning failed. Vulnerabilities found."
    exit 1
else
    echo "Image scanning passed. No vulnerabilities found."
fi