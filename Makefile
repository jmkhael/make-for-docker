include make_env

NS ?= jmkhael
VERSION ?= latest

IMAGE_NAME ?= mx-fs
CONTAINER_NAME ?= mx-fs
CONTAINER_INSTANCE ?= default

.PHONY: build build-arm push push-arm shell shell-arm run run-arm start start-arm stop stop-arm rm rm-arm release release-arm

build: Dockerfile
    docker build -t $(NS)/$(IMAGE_NAME):$(VERSION) -f Dockerfile .

build-arm: Dockerfile.arm
    docker build -t $(NS)/rpi-$(IMAGE_NAME):$(VERSION) -f Dockerfile.arm .

push:
    docker push $(NS)/$(IMAGE_NAME):$(VERSION)
    
push-arm:
    docker push $(NS)/rpi-$(IMAGE_NAME):$(VERSION)

shell:
    docker run --rm --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) -i -t $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION) /bin/bash

shell-arm:
    docker run --rm --name rpi-$(CONTAINER_NAME)-$(CONTAINER_INSTANCE) -i -t $(PORTS) $(VOLUMES) $(ENV) $(NS)/rpi-$(IMAGE_NAME):$(VERSION) /bin/bash

run:
    docker run --rm --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION)

run-arm:
    docker run --rm --name rpi-$(CONTAINER_NAME)-$(CONTAINER_INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/rpi-$(IMAGE_NAME):$(VERSION)

start:
    docker run -d --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION)

start-arm:
    docker run -d --name rpi-$(CONTAINER_NAME)-$(CONTAINER_INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/rpi-$(IMAGE_NAME):$(VERSION)

stop:
    docker stop $(CONTAINER_NAME)-$(CONTAINER_INSTANCE)

stop-arm:
    docker stop rpi-$(CONTAINER_NAME)-$(CONTAINER_INSTANCE)

rm:
    docker rm $(CONTAINER_NAME)-$(CONTAINER_INSTANCE)

rm-arm:
    docker rm rpi-$(CONTAINER_NAME)-$(CONTAINER_INSTANCE)

release: build
    make push -e VERSION=$(VERSION)
    
release-arm: build-arm
    make push-arm -e VERSION=$(VERSION)

default: build

