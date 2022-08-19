REGISTRY                    := eu.gcr.io/gardener-project/test/martinweindel
REPO_ROOT                   := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
GOVERSION                   := 1.18.5
INSTALL_DOCKER_CE_CLI       := wget -q https://download.docker.com/linux/debian/dists/bullseye/pool/stable/amd64/docker-ce-cli_20.10.9~3-0~debian-bullseye_amd64.deb; dpkg -i docker-ce-cli_20.10.9~3-0~debian-bullseye_amd64.deb
REV                         := v3.5.0-1
IMAGE_NAME_TAG              := $(REGISTRY)/csi-attacher:$(REV)

.PHONY: download
download:
	wget -O- -L https://github.com/kubernetes-csi/external-attacher/archive/refs/tags/v3.5.0.tar.gz |tar xvz

.PHONY: build
build:
	docker run --rm -v $(REPO_ROOT)/external-attacher-3.5.0:/src golang:$(GOVERSION) bash -c \
	  "cd /src; make build BUILD_PLATFORMS='linux amd64 amd64' GOFLAGS_VENDOR=-mod=vendor"

.PHONY: container
container:
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $(REPO_ROOT)/external-attacher-3.5.0:/src golang:$(GOVERSION) bash -c \
	  "$(INSTALL_DOCKER_CE_CLI); cd /src; make container REV=$(REV) REGISTRY_NAME=$(REGISTRY) BUILD_PLATFORMS='linux amd64 amd64' GOFLAGS_VENDOR=-mod=vendor"

.PHONY: push
push:
	docker tag csi-attacher:latest $(IMAGE_NAME_TAG)
	docker push $(IMAGE_NAME_TAG)

all: download container push
