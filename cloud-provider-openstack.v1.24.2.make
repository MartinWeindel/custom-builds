REGISTRY                    := eu.gcr.io/gardener-project/test/martinweindel
REPO_ROOT                   := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
GOVERSION                   := 1.18.5
INSTALL_DOCKER_CE_CLI       := wget -q https://download.docker.com/linux/debian/dists/bullseye/pool/stable/amd64/docker-ce-cli_20.10.9~3-0~debian-bullseye_amd64.deb; dpkg -i docker-ce-cli_20.10.9~3-0~debian-bullseye_amd64.deb
REV                         := v1.24.2-1
IMAGE1_NAME_TAG             := $(REGISTRY)/openstack-cloud-controller-manager-amd64:$(REV)
IMAGE2_NAME_TAG             := $(REGISTRY)/cinder-csi-plugin-amd64:$(REV)

.PHONY: download
download:
	wget -O- -L https://github.com/kubernetes/cloud-provider-openstack/archive/refs/tags/v1.24.2.tar.gz |tar xvz

.PHONY: images
images:
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $(REPO_ROOT)/cloud-provider-openstack-1.24.2:/src golang:$(GOVERSION) bash -c \
	  "$(INSTALL_DOCKER_CE_CLI); cd /src; make build-images IMAGE_NAMES='openstack-cloud-controller-manager cinder-csi-plugin' VERSION=$(REV) REGISTRY=$(REGISTRY)"

.PHONY: push
push:
	docker push $(IMAGE1_NAME_TAG)
	docker push $(IMAGE2_NAME_TAG)

all: images push
