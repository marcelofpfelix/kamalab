#!/bin/bash

file=${KAMA_CFG:-"kamailio"}

# start
while :; do
  echo
  echo Starting $file
  date
  echo

  # check if config is valid
  kamailio -c -f /etc/kamailio/${file}
  if [ $? -eq 0 ]; then
    echo "The output was from config validation, stating kamailio now..."
    echo
    # start kamailio
    kamailio -u kamailio -DDE -f /etc/kamailio/${file}
    exit=$?
    if [ $exit -ne 0 ]; then
      sleep 5
    fi
    # kamailio got killed
    echo "Kamailio exited with $exit - restarting $file..." >&2
    # if exited with error
  # invalid config
  else
    sleep 5
  fi
done
