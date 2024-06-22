### sipbox

- reload option

### testing

- use TDD for kemi


### private subnets

use 100.100.0.1/24 for the private network


```sh

## tcp
sipexer tcp:10.0.0.1:5060

  ## sip a sip client to answer the request
~ $ docker run -ti --rm --net host --name pjsua marcelofpfelix/pjsua --log-level=3 --app-log-level=3 --no-stderr --color --light-bg --snd-auto-close=0 --no-vad --auto-answer=200 --max-calls=4 --duration=90 --id='sip:pjsua@pjsua:5060;transport=udp' --use-timer=1 --clock-rate 44100 --snd-clock-rate 44100 --null-audio --rtcp-mux --add-codec=PCMU/8000/1 --no-tcp --auto-update-nat=1 --disable-stun --local-port=5001  --bound-addr=10.0.0.2 --rtp-port=59634

  ## send a INVITE to your private ip
~ $ sipexer -i -vl 3 -co -com -sd -su -cb -sw 10000 192.0.2.1

  ## send options from different private ip
~ $ sipexer -laddr 10.0.0.1:15060 10.0.0.1


# calculate the SIP-body length in bytes (with LF replaced with CRLF)
bodylen=$(sed -e '1,/^$/ d;s/$/\r/' mime.yml | wc -c)

# send, with two header fields updated
cat ~/git/marcelofpfelix/kamalab/tmp/mime_video.yml |\
   sed -e "s/^\(Call-ID\|i\)\? *:.*/Call-ID: `uuidgen`/i" \
       -e 's/$/\r/' |\
   nc -q 5 -u 192.0.2.1 5060

#       -e "s/^\(Content-Length\|L\) *:.*/Content-Length: $bodylen/i" \

```


### mime
https://www.rfc-editor.org/rfc/rfc2045
https://www.rfc-editor.org/rfc/rfc5621
https://lists.kamailio.org/pipermail/sr-users/2013-July/078797.html



--------------------------------------------------------------------------------
```sh
#!/bin/bash

# List of versions
versions=("5.6.5" "5.7.3" "5.7.2")

# Initialize variable to store the latest version
latest_version="0"

# Loop through the versions to find the latest
for version in "${versions[@]}"; do
    if dpkg --compare-versions "$version" gt "$latest_version"; then
        latest_version="$version"
    fi
done

echo "The latest version is: $latest_version"
```
--------------------------------------------------------------------------------
