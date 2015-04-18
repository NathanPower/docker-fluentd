#!/bin/bash
docker rm -f daemon_dave
docker rm -f docker_fluentd
docker build -t="nathanpower/docker-fluentd" .
docker run -e HOST="$(uname -n)" -e FLUENTD_METERING_IP="172.17.0.41" --name docker_fluentd -d -v /sys/fs/cgroup:/mnt/cgroup -v /var/lib/docker/containers:/var/lib/docker/containers -v /var/run/docker.sock:/var/run/docker.sock nathanpower/docker-fluentd 
docker run --name daemon_dave -d ubuntu /bin/sh -c "while true; do echo hello world; sleep 30; done"
#sleep 10
#docker stop daemon_dave
#docker stop docker_fluentd
#cat /var/lib/docker/containers/$container_id/${container_id}-json.log
