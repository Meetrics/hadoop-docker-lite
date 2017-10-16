#!/bin/bash

: ${HADOOP_PREFIX:=/usr/local/hadoop}

$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

# altering the core-site configuration
sed s/HOSTNAME/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml

service ssh start
$HADOOP_PREFIX/sbin/start-dfs.sh
$HADOOP_PREFIX/sbin/start-yarn.sh

# Try to copy all the files in the mounted $HDFS_UPLOAD volume (if any) to hdfs root
echo "Copying $HDFS_UPLOAD files into HDFS ..."
if [ "$(ls -A $HDFS_UPLOAD)" ]; then
    while true; do
      hdfs dfs -put $HDFS_UPLOAD/* / 2> /dev/null
      if [ $? -eq 0 ]; then
    	  break
      fi
      sleep 1
    done
    echo " '--> Files successfully copied!"
else
    echo " '--> No file to copy"
fi



if [[ $1 == "-d" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi
