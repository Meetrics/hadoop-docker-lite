# Hadoop docker image
This is a hadoop docker build project on Debian Linux distro.

## Version
2.7.1


## Building the image
- ``docker build -t meetrics/hadoop_debian:2.7.1 .``

## Copy files from host fs to HDFS inside of the container
Put the files that you want to copy to hdfs in the "hdfs-upload" folder and (re)run the container

## Running
- ``docker run --name hadoop -p 49707:49707 -p 50010:50010 -p 50020:50020 -p 50030:50030 -p 50070:50070 -p 50075:50075 -p 50090:50090 -p 8030:8030 -p 8031:8031 -p 8032:8032 -p 8033:8033 -p 8040:8040 -p 8042:8042 -p 8088:8088 -it meetrics/hadoop_debian:2.7.1``

or

- ``docker-compose up``

## UI
- http://localhost:8088/

