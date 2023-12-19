#!/bin/bash

# default interface
link=$(ip r | grep '^default' | grep -oP '(?<=dev\s)\w+' | head -n 1)

# subnet for docs
subnet=192.0.2

# number of ips
ips=${1:-10} # default is 10

for ((i=1;i<=ips;i++)); do
  sudo ip addr add $subnet.$i dev $link 2>/dev/null
done


# update kamailio repo
cd ~/git/kamailio/kamailio
git pull
