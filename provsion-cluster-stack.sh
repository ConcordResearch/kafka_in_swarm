#!/bin/bash

CMD_ROOT="/vagrant"
LEADER_NODE="dock-node-001"
DELAY=5

echo "*********************"
echo "Starting process"
echo "*********************"
vagrant up

echo "Making scripts executable"
find ./docker -name "*.sh" -exec chmod +x {} \;
find ./kafka -name "*.sh" -exec chmod +x {} \;

echo "Build swarm"
vagrant ssh -c "${CMD_ROOT}/kafka/start-swarm.sh" ${LEADER_NODE}
vagrant ssh -c "${CMD_ROOT}/tmp/join-swarm.sh" dock-node-002
vagrant ssh -c "${CMD_ROOT}/tmp/join-swarm.sh" dock-node-003
vagrant ssh -c "${CMD_ROOT}/tmp/join-swarm.sh" dock-node-004
vagrant ssh -c "${CMD_ROOT}/tmp/join-swarm.sh" dock-node-005

echo "Add second manager node"
vagrant ssh -c "docker node promote dock-node-002" ${LEADER_NODE}

echo "Start swarm visualizer"
vagrant ssh -c "${CMD_ROOT}/kafka/start-swarm-vis.sh" ${LEADER_NODE}

echo "Label nodes so that you can target zookeeper and kafka"
vagrant ssh -c "${CMD_ROOT}/kafka/label-kafka-nodes.sh" ${LEADER_NODE}

echo "Installing kafka container on nodes"
vagrant ssh -c "${CMD_ROOT}/kafka/kafka-image-save.sh" dock-node-001
vagrant ssh -c "${CMD_ROOT}/kafka/kafka-image-load.sh" dock-node-002
vagrant ssh -c "${CMD_ROOT}/kafka/kafka-image-load.sh" dock-node-003
vagrant ssh -c "${CMD_ROOT}/kafka/kafka-image-load.sh" dock-node-004
vagrant ssh -c "${CMD_ROOT}/kafka/kafka-image-load.sh" dock-node-005

echo "Start zookeeper"
vagrant ssh -c "${CMD_ROOT}/kafka/start-zookeeper-stack.sh" ${LEADER_NODE}

echo "Wait to make sure zookeeper is up"
sleep $DELAY

echo "Start kafka nodes"
vagrant ssh -c "${CMD_ROOT}/kafka/start-kafka-stack.sh" ${LEADER_NODE}

echo "Wait to make sure kafka is up"
sleep $DELAY

vagrant ssh -c "${CMD_ROOT}/kafka/test-topic-lifecycle.sh example-topic" dock-node-002

