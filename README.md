# Putting Kafka in a Docker Swarm

- <https://medium.com/@NegiPrateek/wtf-setting-up-kafka-cluster-using-docker-swarm-6429bdb5784b>
- <https://medium.com/@NegiPrateek/wtf-setting-up-kafka-cluster-using-docker-stack-5efc68841c23>
- <https://medium.com/@NegiPrateek/starting-kafka-cluster-as-a-single-docker-service-a-fallacy-90736254e02c>

## Requirements

- Vagrant (2.1.1)
  - Using bento/ubuntu-16.04
- Docker (18.06.0-ce)
- docker compose (1.22.0)
- Kafka docker image used by process is here;
  - <https://hub.docker.com/r/exampleplatform/kafka/>
    - downloaded once and then copied to each VM through the standard Vagrant share. This is in an effort to not pull for each VM

Get the path to a volume, so that you can tar it.
<https://stackoverflow.com/questions/21597463/how-to-port-data-only-volumes-from-one-host-to-another>


``` shell
 docker volume inspect zoo-data | jq  '.[0].Mountpoint'
```
