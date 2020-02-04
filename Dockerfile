FROM alpine:3.8 as secretless-k8s-demo

RUN apk add --no-cache \
    bash \
    curl \
    docker \
    git \
    jq \
    openssl \
    shadow \
    vim \
    wget

# Add Limited user
RUN groupadd -r secretless \
             -g 777 && \
    useradd -c "secretless runner account" \
            -g secretless \
            -u 777 \
            -m \
            -r \
            secretless && \
    usermod -aG docker secretless

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

# Install helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh

# Install Grafana helm charts
RUN cd /root && \
    git clone https://github.com/pivotal-cf/charts-grafana

COPY secretless_demo_runner /
COPY kind.yml scripts/ /root/

ENV PATH="${PATH}:/root"

ENTRYPOINT ["/bin/bash", "/secretless_demo_runner"]
