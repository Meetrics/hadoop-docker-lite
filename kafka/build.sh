#!/bin/sh
docker build -t gia90/kafka_alpine:0.10.2.1 . 
docker pull sheepkiller/kafka-manager
