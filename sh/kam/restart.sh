#!/bin/bash

file=${KAMA_CONF:-"kamailio"}

echo $file
# start
while kamailio -u kamailio -DDE -f /etc/kamailio/${file}.cfg; do
  date; echo "Kamailio exited with $? - restarting $file..." >&2
  #
done
