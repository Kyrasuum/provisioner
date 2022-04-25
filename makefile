.PHONY: all build clean

all: build clean

build:
	docker build -t test-env . && docker run -it test-env bash

clean:
	docker rmi test-env --force
