# Makefile



KAMA_CONF ?= cfg/1-types/1.0.0-stateless
KAMA_IMG ?= 5.7.2-bookworm
KAMA_LISTEN ?= 192.0.2.1

EXTRA_ENV := KAMA_CONF=$(KAMA_CONF) KAMA_IMG=$(KAMA_IMG) KAMA_LISTEN=$(KAMA_LISTEN)


################################################################################
# sh
################################################################################

run: ## run app
	$(EXTRA_ENV) docker compose down
	$(EXTRA_ENV) docker compose -p kam up --force-recreate -V -d app


init: ## initialize project
	bash ./sh/init.sh
	$(EXTRA_ENV) docker compose pull


################################################################################
# general
################################################################################

pre: ## run pre-commit
	pre-commit run --all-files

help: ## show help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage: \033[36m\033[0m\n"} /^[$$()% 0-9a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s:\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\asd033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
