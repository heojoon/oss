#!/bin/bash

#
# apache kafka cluster initial
# 

# Multi Broker Kafka image
#
# Ref : https://hub.docker.com/r/wurstmeister/kafka/

# * Tutorial
# http://wurstmeister.github.io/kafka-docker/

# Install Path
DIR=/app/docker

# If not exist path than make directory.
[ ! -e "${DIR}" ] {
    mkdir -p ${DIR}
}

cd ${DIR}

git clone https://github.com/wurstmeister/kafka-docker


docker-compose up -d

docker scale kafka=2

docker-compose ps

# TEST
# create topics
$KAFKA_HOME/bin/kafka-topics.sh --create --topic topic --partitions 4 --zookeeper $ZK --replication-factor 2

# topics describe
$KAFKA_HOME/bin/kafka-topics.sh --describe --topic topic --zookeeper $ZK 

# producer
$KAFKA_HOME/bin/kafka-console-producer.sh --topic=topic --broker-list=`broker-list.sh`

# consumer (another shell)
$ $KAFKA_HOME/bin/kafka-console-consumer.sh --topic=topic --zookeeper=$ZK




