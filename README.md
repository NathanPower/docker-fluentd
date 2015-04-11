# Docker-Fluentd: the Container to Log Other Containers' Logs

## What

By running this container with the following command, one can aggregate the logs of Docker containers running on the same host, and include extra data such as host name, image name, and container name:

```
docker run -e HOST="$(uname -n)" -d -v /var/lib/docker/containers:/var/lib/docker/containers -v /var/run/docker.sock:/var/run/docker.sock nathanpower/docker-fluentd
```

For the moment, the container logs are stored in /var/lib/docker/containers/yyyyMMdd.log on the host. Going forward the plan is to output the data to another fluentd instance oer TCP. The data is buffered, so you may also see buffer files like /var/lib/docker/containers/20141114.b507c71e6fe540eab.log where "b507c71e6fe540eab" is a hash identifier. You can mount that container volume back to host. Also, by modifying `fluent.conf` and rebuilding the Docker image, you can stream up your logs to LogEntries, Elasticsearch, Amazon S3, MongoDB, Treasure Data, or another FluentD instance.

The output log looks exactly like Docker's JSON formatted logs, with extra information about the container and host:

```
{
  "log": "hello world\n",
  "stream": "stdout",
  "host": "osboxes",
  "id": "72ad1000beb1",
  "image": "ubuntu:14",
  "name": "daemon_dave",
  "time": "2015-04-11T18:50:44+00:00"
}

```

## How

`docker-fluentd` uses [Fluentd](https://www.fluentd.org) inside to tail log files that are mounted on `/var/lib/docker/containers/<CONTAINER_ID>/<CONTAINER_ID>-json.log`. It uses the [tail input plugin](https://docs.fluentd.org/articles/in_tail) to tail JSON-formatted log files that each Docker container emits.

The tags are modified to include details such as container name, image name, and container id using [tag resolver](https://github.com/ainoya/fluent-plugin-docker-tag-resolver). This data is added to the log event using the [record reformer](https://github.com/sonots/fluent-plugin-record-reformer), before writing out to local files using the [file output plugin](https://docs.fluentd.org/articles/out_file).


