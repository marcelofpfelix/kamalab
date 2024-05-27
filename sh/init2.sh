#!/bin/bash


# requirements
# fzf, docker
#

# ##############################################################################
# config
# ##############################################################################

# subnet for docs
# 192.0.2
# local subnet
subnet=127.0.0
# Check latest kamailio versions:
  # https://github.com/kamailio/kamailio/pkgs/container/kamailio-master-devcontainer
    # kamailio-master-devcontainer:latest
  # https://github.com/kamailio/kamailio-docker/pkgs/container/kamailio
    # kamailio:5.7.4-bookworm
kama_img=kamailio:5.7.4-bookworm
# where kamailio will listen
kama_listen=127.0.0.3
# local kamailio repo
kama_repo=~/git/kamailio/kamailio

# if no argument is passed, use the default
if [[ -z $1 ]]; then
  cd ~/git/marcelofpfelix/kamalab/
  kama_cfg=$(find cfg -type f -exec ls -1t "{}" + | fzf)
else
  kama_cfg=$1
fi

# number of ips
ips=${2:-10} # default is 10


# ##############################################################################
# init
# ##############################################################################

# default interface
link=lo # $(ip r | grep '^default' | grep -oP '(?<=dev\s)\w+' | head -n 1)

for ((i=1;i<=ips;i++)); do
  sudo ip addr add $subnet.$i dev $link 2>/dev/null
done

echo Added ${subnet}.1..${ips} ips to $link
echo

# update kamailio repo
cd $kama_repo
git clone git@github.com:kamailio/kamailio.git $kama_repo 2>/dev/null
git pull
cd ~/git/marcelofpfelix/kamalab/

echo
echo Starting $kama_cfg with $kama_img listening on $kama_listen
echo

export KAMA_IMG=$kama_img
export KAMA_CFG=$kama_cfg
export KAMA_LISTEN=$kama_listen

docker compose pull
docker compose down
docker compose -p kam2 up --force-recreate -V -d kam2
