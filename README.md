# kamalab


Configs used by the `kamailio by example` lab, in [bandonga.com/kamailio](https://bandonga.com/kamailio/).


```sh

    ## Preparation
git clone git@github.com:marcelofpfelix/kamalab.git ~/git/marcelofpfelix/kamalab
git clone git@github.com:kamailio/kamailio.git ~/git/kamailio/kamailio
cd ~/git/marcelofpfelix/kamalab

    ## running
make init
export KAMA_CONF=cfg/1-types/1.0.0-stateless
make run
make help
```
