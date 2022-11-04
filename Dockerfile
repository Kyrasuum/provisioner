FROM ubuntu:22.04
RUN apt update
# sudo and wget are needed to test
RUN apt install -y sudo wget
RUN useradd -ms /bin/bash docker && echo "docker:docker" | chpasswd && adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER docker
WORKDIR /home/docker
ENV CROSS_DOCKER_IN_DOCKER=true
RUN sh -c "$(wget https://raw.githubusercontent.com/kyrasuum/provisioner/main/provision.sh -O -)" 2>&1
