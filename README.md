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
- envtpl/envtpl
- marcelofpfelix/boa
- inotifywait from inotify-tools
```

### How it works

The cli is done with [boa](https://github.com/marcelofpfelix/boa) and jinja2 templates with `envtpl`.

A Docker container starts with a ghcr.io/kamailio image.
This container shares a volume in `/etc/kamailio` and uses a custom entrypoint to start the `fzf` selected config file.

After that, `parallel` runs 2 tasks:
- tail of docker logs and
- `inotifywait` that restarts kamailio on file changes.

This setup allows you to test different configurations easily and see the results in real-time.
