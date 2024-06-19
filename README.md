# kamalab


Configs used by the `kamailio by example` lab, in [bandonga.com/kamailio](https://bandonga.com/kamailio/).


```sh
    ## Preparation
git clone git@github.com:marcelofpfelix/kamalab.git ~/git/marcelofpfelix/kamalab
cd ~/git/marcelofpfelix/kamalab

    ## running
./kamalab
```

##### Requirements

```yml
- docker
- junegunn/fzf
- gnu parallel
```

### How it works
A Docker container starts with a ghcr.io/kamailio image.
This container shares a volume in `/etc/kamailio` and uses the entrypoint to start the `fzf` selected config file: `kamailio -u kamailio -DDE -f /etc/kamailio/${file}`

After that, `parallel` runs 2 tasks:
- tail of docker logs and
- `inotifywait` that restarts kamailio on file changes.

This setup allows you to test different configurations easily and see the results in real-time.
