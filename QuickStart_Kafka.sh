#!/bin/bash

#
# 2. Quick start kafka
#
# Recommend pure CentOS environment avoid conflict install path.
#

#
# Ref : https://kafka.apache.org/quickstart
#

# Environments
INSTALL_PATH="/app"

mkdir ${INSTALL_PATH} 
cd ${INSTALL_PATH}

# 1. Download the code

curl -O -q http://mirror.apache-kr.org/kafka/2.0.0/kafka_2.11-2.0.0.tgz
tar zxvf kafka_2.11-2.0.0.tgz
ln -s kafka_2.11-2.0.0 kafka
cd kafka

# 2. Start the server
# Kafka uses ZooKeeper so you need to first start a ZooKeeper server if you don't already have one. You can use the convenience script packaged with kafka to get a quick-and-dirty single-node ZooKeeper instance.

bin/zookeeper-server-start.sh config/zookeeper.properties


# 3. Create a topic
# Let's create a topic named "test" with a single partition and only one replica:

bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test
bin/kafka-topics.sh --list --zookeeper localhost:2181


# 4. Send some messages
bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test

# 5. Start a consumer
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning

# Step 6: Setting up a multi-broker cluster
cp config/server.properties config/server-1.properties
cp config/server.properties config/server-2.properties

# Edit
#config/server-1.properties:
#    broker.id=1
#    listeners=PLAINTEXT://:9093
#    log.dirs=/tmp/kafka-logs-1
# 
#config/server-2.properties:
#    broker.id=2
#    listeners=PLAINTEXT://:9094
#    log.dirs=/tmp/kafka-logs-2

# We already have Zookeeper and our single node started, so we just need to start the two new nodes:
bin/kafka-server-start.sh config/server-1.properties &
bin/kafka-server-start.sh config/server-2.properties &

# Now create a new topic with a replication factor of three:
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 1 --topic my-replicated-topic

# "describe topics" command for my-replicated-topic
bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic my-replicated-topic

#  same command on the original topic that test
bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic test

# result : So there is no surprise there—the original topic has no replicas and is on server 0, the only server in our cluster when we created it.

# Let's publish a few messages to our new topic:
bin/kafka-console-producer.sh --broker-list localhost:9092 --topic my-replicated-topic

# Now let's consume these messages:
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --from-beginning --topic my-replicated-topic

# Now let's test out fault-tolerance. Broker 1 was acting as the leader so let's kill it:
# KILL node
ps aux | grep server-1.properties | awk '{print $9}' | xargs kill -9
# Check Dscribe
bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic my-replicated-topic
# If leader Down , But the messages are still available for consumption even though the leader that took the writes originally is down:
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --from-beginning --topic my-replicated-topic

# Step 7: Use Kafka Connect to import/export data
bin/connect-standalone.sh config/connect-standalone.properties config/connect-file-source.properties config/connect-file-sink.properties

# ( Not Working part ) Note that the data is being stored in the Kafka topic connect-test, so we can also run a console consumer to see the data in the topic (or use custom consumer code to process it): 
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic connect-test --from-beginning

# add data file
echo Another line>> test.txt

# view the file
echo test.sink.txt

# More text add and stream view test
tail -f test.sink.txt
while (:) ; do date >> test.txt ; done



