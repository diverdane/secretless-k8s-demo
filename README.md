# CyberArk Secretless Broker Kubernetes Demo

## All you need is Docker!

The CyberArk Secretless Broker Kubernetes Demo provides a demonstration
of how the [Secretless Broker](https://github.com/cyberark/secretless-broker) can be used on a Kubernetes platform.

![Secretless Broker Architecture](https://github.com/cyberark/secretless-broker/blob/master/docs/img/secretless_architecture.svg)

To run the Secretless Broker demo, there is no need to have a priori access
to a Kubernetes cluster, nor is there a need to install the kubectl client
binary on your host. When you run the Secretless Broker demo container,
it will spin up a containerized Kubernetes cluster using Kubernetes-in-Docker
(or kind).

It will also deploy a pod that contains a "Pet Store" application container
as well as a Secretless Broker sidecar container, and a PostGres database
that is configured for authentication.

## Running the Secretless Broker Demo

To run the demo, run the following command:
```
docker run --rm --name secretless-demo-client -p 30303:8001 -p 3000:3000 -v /var/run/docker.sock:/var/run/docker.sock -it diverdane/secretless-k8s-demo
```

The container will:
* Spin up a containerized Kubernetes cluster (in separate container(s)) using Kind
* Deploy a Kubernetes Dashboard
* Run the Secretless demo scripts to deploy the Pet Store with Secretless sidecar
* Leave you in a shell that has kubectl access and some scripts to add and list pets.

## TODO
- Switch to Docker-in-Docker (run Kind containers in this container) instead of Docker-on-Docker
- Figure out 'kubectl proxy' command and necessary authen tokens to get
  access to the Kubernetes dashboard from the Docker host.
- Figure out why the demo script sometimes times out.
- Add environment variables or command line flags for:
    + Setting Kubernetes version for both KinD and kubectl
    + Creating a multinode Kubernetes cluster
    + Running in IPv6 mode (why the Hell not?)


