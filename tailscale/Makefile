## PROLOG

.PHONY: help all

CMDNAME=lab
CMDDESC=tailscale

help: ## Print this help
	@./help.sh '$(CMDNAME)' '$(CMDDESC)'

all: dc-devgen ## Default


## DOCKER COMPOSE ENV

DC_ANVIL_SRC=dc.anvil
DC_ANVIL_MAIN=$(DC_ANVIL_SRC)/component.yaml
DC_ANVIL_OUT=dc.anvil_out
DC_PROJECT=lab

.PHONY: dc-init dc-config dc-devgen dc-dryrun dc-devup dc-devdown

dc-init: ## Init secrets
	./init.sh

dc-config: ## Set manual secrets
	./config.sh

dc-devgen: ## Generate docker-compose resources
	if [ -d $(DC_ANVIL_OUT) ]; then rm -r $(DC_ANVIL_OUT); fi
	anvil component -i $(DC_ANVIL_SRC) -o $(DC_ANVIL_OUT) -c $(DC_ANVIL_MAIN)
	./genenv.sh

dc-dryrun: ## View docker-compose config
	docker-compose -p $(DC_PROJECT) -f $(DC_ANVIL_OUT)/lab/docker-compose.yaml config

dc-devup: ## Deploy docker-compose resources
	docker-compose -p $(DC_PROJECT) -f $(DC_ANVIL_OUT)/lab/docker-compose.yaml up -d

dc-devdown: ## Destroy docker-compose resources
	docker-compose -p $(DC_PROJECT) -f $(DC_ANVIL_OUT)/lab/docker-compose.yaml down

.PHONY: login

login: ## Login to tailscale
	sudo ./dc.anvil_out/lab/login.sh
