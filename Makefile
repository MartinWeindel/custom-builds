REGISTRY                    := eu.gcr.io/gardener-project/test/martinweindel

%.done: %.make
	make -f $^ all REGISTRY=$(REGISTRY)
	docker images | head > $@

all: $(wildcard *.done)
