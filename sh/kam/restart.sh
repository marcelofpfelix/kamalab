#!/bin/bash

file=${KAMA_CFG:-"kamailio"}

echo Starting $file
echo
# start
while kamailio -u kamailio -DDE -f /etc/kamailio/${file}; do
  date; echo "Kamailio exited with $? - restarting $file..." >&2
done
