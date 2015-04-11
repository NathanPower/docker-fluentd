#!/bin/bash
cd /home/nathan/workspaces/docker-fluentd
docker rm -f `docker ps -a -q`
docker build -t="nathanpower/docker-fluentd" .
container_id=$(docker run  --name docker_fluentd -d -v /var/lib/docker/containers:/var/lib/docker/containers -v /var/run/docker.sock:/var/run/docker.sock  nathanpower/docker-fluentd)
docker run --name daemon_dave -d ubuntu /bin/sh -c "while true; do echo hello world; sleep 1; done"
sleep 10
docker stop daemon_dave
#docker stop docker_fluentd
#cat /var/lib/docker/containers/$container_id/${container_id}-json.log
