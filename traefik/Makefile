## PROLOG

.PHONY: help all

CMDNAME=lab
CMDDESC=traefik

help: ## Print this help
	@./help.sh '$(CMDNAME)' '$(CMDDESC)'

all: devgen ## Default


## DOCKER COMPOSE ENV

DC_ANVIL_SRC=dc.anvil
DC_ANVIL_MAIN=$(DC_ANVIL_SRC)/component.yaml
DC_ANVIL_OUT=dc.anvil_out
DC_PROJECT=traefik
DC_ARGS=-p $(DC_PROJECT) -f $(DC_ANVIL_OUT)/traefik/docker-compose.yaml

.PHONY: init devgen dryrun devup devdown

init: ## Init secrets
	./init.sh

devgen: ## Generate docker-compose resources
	if [ -d $(DC_ANVIL_OUT) ]; then rm -r $(DC_ANVIL_OUT); fi
	anvil component -i $(DC_ANVIL_SRC) -o $(DC_ANVIL_OUT) -c $(DC_ANVIL_MAIN)

dryrun: ## View docker-compose config
	docker-compose $(DC_ARGS) config

devup: ## Deploy docker-compose resources
	docker-compose $(DC_ARGS) up -d

devdown: ## Destroy docker-compose resources
	docker-compose $(DC_ARGS) down
