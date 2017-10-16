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
echo "Copying $HDFS_UPLOAD files into HDFS, logging to $HDFS_UPLOAD_LOG ..."

if [ "$(ls $HDFS_UPLOAD)" ]; then
    echo "Polling HDFS till it exits SAFEMODE" > "$HDFS_UPLOAD_LOG"
    while true; do
      HDFS_SAFEMODE=$(hdfs dfsadmin -safemode get | grep "ON")
      if [ -z "$HDFS_SAFEMODE" ]; then
         echo "Safe mode is (finally) OFF!" >> "$HDFS_UPLOAD_LOG"
         break
      fi
      echo "$HDFS_SAFEMODE" >> "$HDFS_UPLOAD_LOG"
      sleep 1
    done
    echo "Copying files to HDFS" >> "$HDFS_UPLOAD_LOG"
    hdfs dfs -put $HDFS_UPLOAD/* / &>> "$HDFS_UPLOAD_LOG"
    echo " '--> Files successfully copied! (exit code: $?)"
else
    echo " '--> No file to copy"
fi



if [[ $1 == "-d" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi
