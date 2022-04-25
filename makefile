.PHONY: all build clean

all: build clean

build:
	@bash -c "docker build -t test-env ."
	@bash -c "docker run -it --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /var/run/docker.sock:/var/run/docker.sock --device=/dev/dri:/dev/dri test-env bash"

clean:
	@bash -c "docker rmi test-env --force || :"
