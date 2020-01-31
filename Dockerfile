FROM ubuntu:18.04

# make systemd behave correctly in Docker container
# (e.g. accept systemd.setenv args, etc.)
ENV container docker

ENV ARCH amd64
ENV DIND_STORAGE_DRIVER vfs
ENV DOCKER_IN_DOCKER_ENABLED "true"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get -y install \
    aufs-tools \
    bind9 \
    bridge-utils \
    curl \
    cgroupfs-mount \
    dmsetup \
    docker.io \
    ipcalc \
    iproute2 \
    iputils-ping \
    jq \
    kmod \
    liblz4-tool \
    net-tools \
    tcpdump \
    vim \
    wget && \
    apt-get -y autoremove && \
    apt-get clean

# Clone CyberArk secretless-broker
# TODO: Replace this with a filtered git clone to just retrieve the K8s
# demo scripts.
# TODO: Should this be moved to the runner so that we pick up the latest
# scripts at run time?
RUN cd /root && \
    git clone https://github.com/cyberark/secretless-broker && \
    cd /root/secretless-broker/demos/k8s-demo && \
    sed -i '/Cleaning up/d' 02_app_developer_steps && \
    sed -i '/stop/d' 02_app_developer_steps

# Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.17.0/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# Install Kubernetes in Docker (kind)
RUN curl -Lo ./kind https://github.com/kubernetes-sigs/kind/releases/download/v0.7.0/kind-linux-amd64 && \
    chmod +x ./kind && \
    mv ./kind /usr/local/bin/kind

COPY secretless_demo_runner /
COPY scripts/add_pet scripts/list_pets /root/
ENV PATH="${PATH}:/root"

ENTRYPOINT ["/bin/bash", "/secretless_demo_runner"]
