# Makefile



KAMA_CONF ?= $(find cfg -type f | fzf)
#cfg/1-types/1.0.0-stateless.cfg
# https://github.com/kamailio/kamailio-docker/pkgs/container/kamailio/versions?filters%5Bversion_type%5D=tagged
KAMA_IMG ?= 5.7.4-bookworm
KAMA_LISTEN ?= 192.0.2.1

EXTRA_ENV := KAMA_CONF=$(KAMA_CONF) KAMA_IMG=$(KAMA_IMG) KAMA_LISTEN=$(KAMA_LISTEN)


################################################################################
# sh
################################################################################

run: ## run app
	bash ./sh/init.sh

watch: ## watch for changes and reload
	bash ./sh/ino.sh . de kam killall kamailio

################################################################################
# general
################################################################################

pre: ## run pre-commit
	pre-commit run --all-files

help: ## show help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage: \033[36m\033[0m\n"} /^[$$()% 0-9a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s:\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\asd033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
