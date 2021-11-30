## PROLOG

.PHONY: help all

CMDNAME=lab
CMDDESC=governor

help: ## Print this help
	@./help.sh '$(CMDNAME)' '$(CMDDESC)'

all: devgen ## Default


## DOCKER COMPOSE ENV

DC_ANVIL_SRC=dc.anvil
DC_ANVIL_MAIN=$(DC_ANVIL_SRC)/component.yaml
DC_ANVIL_OUT=dc.anvil_out
DC_PROJECT=govlab
DC_ARGS=-p $(DC_PROJECT) -f $(DC_ANVIL_OUT)/governor/docker-compose.yaml --env-file dc.run/docker-compose.env

.PHONY: init config devgen dryrun devup devdown stopapp

init: ## Init secrets
	./init.sh
	./genenv.sh

config: ## Set manual secrets
	./config.sh
	./genenv.sh

devgen: ## Generate docker-compose resources
	if [ -d $(DC_ANVIL_OUT) ]; then rm -r $(DC_ANVIL_OUT); fi
	anvil component -i $(DC_ANVIL_SRC) -o $(DC_ANVIL_OUT) -c $(DC_ANVIL_MAIN)

dryrun: ## View docker-compose config
	docker-compose $(DC_ARGS) config

devup: ## Deploy docker-compose resources
	docker-compose $(DC_ARGS) up -d

devdown: ## Destroy docker-compose resources
	docker-compose $(DC_ARGS) down

stopapp: ## Stop main app
	docker-compose $(DC_ARGS) stop govlab

## APP BUILD

BIN_NAME=governor
MAIN_PATH=main.go
BIN_DIR=./bin
BIN_PATH=$(BIN_DIR)/$(BIN_NAME)

.PHONY: clean build

clean: ## Remove build artifacts
	if [ -d $(BIN_DIR) ]; then rm -r $(BIN_DIR); fi

build: ## Build app
	mkdir -p $(BIN_DIR)
	CGO_ENABLED=0 go build -trimpath -ldflags "-w -s -X main.GitHash=$$(git rev-parse --verify HEAD)" -o $(BIN_PATH) $(MAIN_PATH)

## DOCKER

DOCKER_NAME=xorkevin/govlab

DOCKER_MAJOR_VERSION=0.2
DOCKER_VERSION=0.2.7-0

DOCKER_LATEST_IMAGE=$(DOCKER_NAME):latest
DOCKER_MAJOR_IMAGE=$(DOCKER_NAME):$(DOCKER_MAJOR_VERSION)
DOCKER_IMAGE=$(DOCKER_NAME):$(DOCKER_VERSION)

.PHONY: build-docker publish-docker docker

build-docker: build ## Build docker image
	docker build -t $(DOCKER_IMAGE) -t $(DOCKER_MAJOR_IMAGE) -t $(DOCKER_LATEST_IMAGE) .

publish-docker: ## Publish docker image
	docker push $(DOCKER_IMAGE)
	docker push $(DOCKER_MAJOR_IMAGE)
	docker push $(DOCKER_LATEST_IMAGE)

docker: build-docker publish-docker ## Release new image

## APP DEPLOY

.PHONY: setupfirst setup

setupfirst: build ## Run app first setup
	$(BIN_PATH) setup --config dc.anvil_out/governor/client.yaml --first

setup: build ## Run app setup
	./setup.sh "$(BIN_PATH)"
