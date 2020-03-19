SHELL = /bin/bash

volume:
	mkdir -p volume/service-{a,b}
	sudo chmod -R g=rwx ./volume

read-only: clean volume build run/service-a run/service-b
	@echo test it!

clean:
	-docker stop service-a service-b
	sudo rm -rf ./volume

run/service-a: clean volume build
	rand_uid=$$RANDOM &&\
	sudo chown -R $$rand_uid:1337 ./volume/service-a && \
	docker run \
		-u $$rand_uid:1337 \
		--workdir /volume \
		--name service-a \
		--rm \
		--read-only \
		-d \
		-v $(PWD)/volume/service-a:/volume:rw ro:latest

run/service-b: clean volume build
	rand_uid=$$RANDOM &&\
	sudo chown -R $$rand_uid:1337 ./volume/service-b && \
	docker run \
		-u $$rand_uid:1337 \
		--workdir /volume \
		--name service-b \
		--rm \
		--read-only \
		-d \
		-v $(PWD)/volume/service-b:/volume:rw ro:latest

run: build
	docker run -it --rm ro:latest

build:
	docker build -t ro:latest .

