include common.mk

INPUT_VERSION               := 3.5.0
SOURCE_REPO                 := kubernetes-csi/external-attacher
GOVERSION                   := 1.18.5
REV                         := v$(INPUT_VERSION)-1
IMAGE_NAME_TAG              := $(REGISTRY)/csi-attacher:$(REV)

.PHONY: download
download:
	cd downloads && wget -q -O- -L https://github.com/$(SOURCE_REPO)/archive/refs/tags/v$(INPUT_VERSION).tar.gz |tar xz

.PHONY: build
build:
	docker run --rm -v $(REPO_ROOT)/downloads/external-attacher-$(INPUT_VERSION):/src golang:$(GOVERSION) bash -c \
	  "cd /src; make build BUILD_PLATFORMS='linux amd64 amd64' GOFLAGS_VENDOR=-mod=vendor"

.PHONY: container
container:
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $(REPO_ROOT)/downloads/external-attacher-$(INPUT_VERSION):/src golang:$(GOVERSION) bash -c \
	  "$(INSTALL_DOCKER_CE_CLI); cd /src; make container REV=$(REV) REGISTRY_NAME=$(REGISTRY) BUILD_PLATFORMS='linux amd64 amd64' GOFLAGS_VENDOR=-mod=vendor"

.PHONY: push
push:
	docker tag csi-attacher:latest $(IMAGE_NAME_TAG)
	docker push $(IMAGE_NAME_TAG)

all: download container push
