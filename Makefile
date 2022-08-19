REGISTRY                    := eu.gcr.io/gardener-project/test/martinweindel

markers/%.done: %.make
	make -f $^ all REGISTRY=$(REGISTRY)
	docker images | head > $@

all: $(wildcard markers/*.done)
