include common.mk

INPUT_VERSION               := 1.22.0
SOURCE_REPO                 := kubernetes/cloud-provider-openstack
GOVERSION                   := 1.18.5
REV                         := v$(INPUT_VERSION)-2
IMAGE1_NAME_TAG             := $(REGISTRY)/openstack-cloud-controller-manager-amd64:$(REV)
IMAGE2_NAME_TAG             := $(REGISTRY)/cinder-csi-plugin-amd64:$(REV)
ALPINE_VERSION              := 3.16.2
DEBIAN_VERSION              := bullseye-v1.3.0
SRC_BASE                    := $(REPO_ROOT)/downloads/cloud-provider-openstack-$(INPUT_VERSION)

.PHONY: download
download:
	cd downloads && wget -q -O- -L https://github.com/$(SOURCE_REPO)/archive/refs/tags/v$(INPUT_VERSION).tar.gz |tar xz

patch:
	sed -i 's/alpine:3.11/alpine:$(ALPINE_VERSION)/' $(SRC_BASE)/cluster/images/openstack-cloud-controller-manager/Dockerfile
	sed -i 's/alpine:3.11/alpine:$(ALPINE_VERSION)/' $(SRC_BASE)/cluster/images/openstack-cloud-controller-manager/Dockerfile.build
	sed -i 's|k8s.gcr.io/build-image/debian-base-.*:v2.1.3|registry.k8s.io/build-image/debian-base:$(DEBIAN_VERSION)|' $(SRC_BASE)/cluster/images/cinder-csi-plugin/Dockerfile
	sed -i 's|k8s.gcr.io/build-image/debian-base-.*:v2.1.3|registry.k8s.io/build-image/debian-base:$(DEBIAN_VERSION)|' $(SRC_BASE)/cluster/images/cinder-csi-plugin/Dockerfile.build

.PHONY: images
images:
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $(SRC_BASE):/src golang:$(GOVERSION) bash -c \
	  "$(INSTALL_DOCKER_CE_CLI); cd /src; make build-images IMAGE_NAMES='openstack-cloud-controller-manager cinder-csi-plugin' VERSION=$(REV) REGISTRY=$(REGISTRY)"

.PHONY: push
push:
	docker push $(IMAGE1_NAME_TAG)
	docker push $(IMAGE2_NAME_TAG)

all: download patch images push