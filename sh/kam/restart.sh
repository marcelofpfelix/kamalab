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
    # start kamailio
    kamailio -u kamailio -DDE -f /etc/kamailio/${file}

    # kamailio got killed
    echo "Kamailio exited with $? - restarting $file..." >&2
    # if exited with error
    if [ $? -ne 0 ]; then
      sleep 5
    fi
  # invalid config
  else
    sleep 5
  fi
done
