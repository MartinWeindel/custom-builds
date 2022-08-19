REGISTRY                    := eu.gcr.io/gardener-project/test/martinweindel
REPO_ROOT                   := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
INSTALL_DOCKER_CE_CLI       := wget -q https://download.docker.com/linux/debian/dists/bullseye/pool/stable/amd64/docker-ce-cli_20.10.9~3-0~debian-bullseye_amd64.deb; dpkg -i docker-ce-cli_20.10.9~3-0~debian-bullseye_amd64.deb
