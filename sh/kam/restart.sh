#!/bin/bash

file=${KAMA_CFG:-"kamailio"}

# start
while :; do
  echo
  echo "#######################################################################"
  echo KAMALAB: Using $file
  date
  echo

  # check if config is valid
  kamailio -c -f /etc/kamailio/${file} &> /tmp/kamalab

  if [ $? -eq 0 ]; then
    echo "KAMALAB: Starting kamailio now..."
    echo
    # start kamailio
    kamailio -u kamailio -DDE -f /etc/kamailio/${file}
    exit=$?
    if [ $exit -ne 0 ]; then
      sleep 5
    fi
    # kamailio got killed
    echo "KAMALAB: Kamailio exited with $exit - restarting $file..."
    # if exited with error
  # invalid config
  else
    echo "KAMALAB: Invalid config"
    echo $(cat /tmp/kamalab)
    sleep 5
  fi
done
