#!/bin/sh
docker build -t meetrics/kafka_alpine:0.10.2.1 . 
docker pull sheepkiller/kafka-manager
