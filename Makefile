markers/%.done: %.make
	make -f $^ all 
	docker images | head > $@

all: $(wildcard markers/*.done)
