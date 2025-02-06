.PHONY: all docker clean

all: docker clean

docker:
	@docker build -t test-env .
	@docker run -it --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /var/run/docker.sock:/var/run/docker.sock --device=/dev/dri:/dev/dri test-env bash || :

vagrant:
	@vagrant up

clean:
	@vagrant down || :
	@rm -rf .vagrant || :
	@docker rmi test-env --force || :
	@docker container prune -f
	@docker system prune -f
