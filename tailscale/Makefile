## PROLOG

.PHONY: help all

CMDNAME=lab
CMDDESC=tailscale

help: ## Print this help
	@./help.sh '$(CMDNAME)' '$(CMDDESC)'

all: devgen ## Default


## DOCKER COMPOSE ENV

DC_ANVIL_SRC=dc.anvil
DC_ANVIL_MAIN=$(DC_ANVIL_SRC)/component.yaml
DC_ANVIL_OUT=dc.anvil_out
DC_PROJECT=tailscale

.PHONY: init config devgen dryrun devup devdown

init: ## Init secrets
	./init.sh

config: ## Set manual secrets
	./config.sh

devgen: ## Generate docker-compose resources
	if [ -d $(DC_ANVIL_OUT) ]; then rm -r $(DC_ANVIL_OUT); fi
	anvil component -i $(DC_ANVIL_SRC) -o $(DC_ANVIL_OUT) -c $(DC_ANVIL_MAIN)
	./genenv.sh

dryrun: ## View docker-compose config
	docker-compose -p $(DC_PROJECT) -f $(DC_ANVIL_OUT)/tailscale/docker-compose.yaml config

devup: ## Deploy docker-compose resources
	docker-compose -p $(DC_PROJECT) -f $(DC_ANVIL_OUT)/tailscale/docker-compose.yaml up -d

devdown: ## Destroy docker-compose resources
	docker-compose -p $(DC_PROJECT) -f $(DC_ANVIL_OUT)/tailscale/docker-compose.yaml down

.PHONY: login

login: ## Login to tailscale
	sudo ./dc.anvil_out/tailscale/login.sh
