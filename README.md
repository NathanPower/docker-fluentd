# Docker-Fluentd: Log container and system logs, and forward to another fluentd instance

## What

By running this container with the following command, one can aggregate the stdout logs and system metrics of Docker containers running on the same host, and include extra data such as host name, image name, and container name:

```
docker run -e HOST="$(uname -n)" -e FLUENTD_METERING_IP=<TARGET IP> --name docker_fluentd -d -v /sys/fs/cgroup:/mnt/cgroup -v /var/lib/docker/containers:/var/lib/docker/containers -v /var/run/docker.sock:/var/run/docker.sock nathanpower/docker-fluentd 
``` 

The output log looks exactly like Docker's JSON formatted logs, with extra information about the container and host:

```
{
  "source": "application", 
  "log": "hello world\n",
  "stream": "stdout",
  "host": "osboxes",
  "short_id": "b049b768ab62",
  "long_id": "b8aa72148d6bd0d01ae21a19e24d74c4ba7efa1826e5eaad7e66a5bee9c36e00",
  "image": "ubuntu:14_04",
  "name": "daemon_dave",
  "timestamp": "2015-04-12T12:39:08+00:00"
}

```

System log:

```
{
  "source": "system",
  "key": "memory_stat_hierarchical_memsw_limit",
  "value": 1.844674407371e+19,
  "type": "gauge",
  "name": "\/daemon_dave",
  "host": "osboxes",
  "short_id": "b049b768ab62",
  "long_id": "b8aa72148d6bd0d01ae21a19e24d74c4ba7efa1826e5eaad7e66a5bee9c36e00",
  "timestamp": "2015-04-12T12:39:39+00:00"
}
```

## How

`docker-fluentd` uses [Fluentd](https://www.fluentd.org) inside to tail log files that are mounted on `/var/lib/docker/containers/<CONTAINER_ID>/<CONTAINER_ID>-json.log`. It uses the [tail input plugin](https://docs.fluentd.org/articles/in_tail) to tail JSON-formatted log files that each Docker container emits. System metrics are gathered using [docker metrics](https://github.com/kiyoto/fluent-plugin-docker-metrics). 

The tags are modified to include details such as container name, image name, and container id using [tag resolver](https://github.com/ainoya/fluent-plugin-docker-tag-resolver). This data is added to the log event using the [record reformer](https://github.com/sonots/fluent-plugin-record-reformer). 

Logs are then forwarded via the [secure forwarding plugin](http://docs.fluentd.org/articles/in_secure_forward) to another fluentd instance. Test this functionality easily with [docker-fluentd-logentries](https://github.com/NathanPower/docker-fluentd-logentries).

## Credit

[kiyoto / docker-fluentd](https://github.com/kiyoto/docker-fluentd)

## Links

- [Fluentd website](https://www.fluentd.org)
- [Fluentd's Repo](https://github.com/fluent/fluentd)
- [Kubernetes's Logging Pod](https://github.com/GoogleCloudPlatform/kubernetes/tree/master/contrib/logging)
