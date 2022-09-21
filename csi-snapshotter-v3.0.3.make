include common.mk

INPUT_VERSION               := 3.0.3
SOURCE_REPO                 := kubernetes-csi/external-snapshotter
REPO_NAME                   := external-snapshotter
GOVERSION                   := 1.19.1
REV                         := v$(INPUT_VERSION)-1
IMAGE_NAME_TAG1             := $(REGISTRY)/csi-snapshotter:$(REV)
IMAGE_NAME_TAG2             := $(REGISTRY)/snapshot-validation-webhook:$(REV)
IMAGE_NAME_TAG3             := $(REGISTRY)/snapshot-controller:$(REV)

.PHONY: download
download:
	cd downloads && wget -q -O- -L https://github.com/$(SOURCE_REPO)/archive/refs/tags/v$(INPUT_VERSION).tar.gz |tar xz

.PHONY: build
build:
	docker run --rm -v $(REPO_ROOT)/downloads/$(REPO_NAME)-$(INPUT_VERSION):/src golang:$(GOVERSION) bash -c \
	  "cd /src; make build BUILD_PLATFORMS='linux amd64' GOFLAGS_VENDOR=-mod=vendor"

.PHONY: container
container:
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $(REPO_ROOT)/downloads/$(REPO_NAME)-$(INPUT_VERSION):/src golang:$(GOVERSION) bash -c \
	  "$(INSTALL_DOCKER_CE_CLI); cd /src; make container REV=$(REV) REGISTRY_NAME=$(REGISTRY) BUILD_PLATFORMS='linux amd64' GOFLAGS_VENDOR=-mod=vendor"

.PHONY: push
push:
	docker tag csi-snapshotter:latest $(IMAGE_NAME_TAG1)
	docker tag snapshot-validation-webhook:latest $(IMAGE_NAME_TAG2)
	docker tag snapshot-controller:latest $(IMAGE_NAME_TAG3)
	docker push $(IMAGE_NAME_TAG1)
	docker push $(IMAGE_NAME_TAG2)
	docker push $(IMAGE_NAME_TAG3)

all: download container push
