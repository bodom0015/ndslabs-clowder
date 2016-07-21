# Clowder in Kubernetes
The scripts and specs contained in this folder will enable you to run Clowder in a raw Kubernetes cluster.

All required images are pushed to Docker Hub.

Simply running the `start.sh` script should pull the necessary images.

NOTE: Running NDSLabs is not required to use the files contained here; only Kubernetes is necessary.

## Getting Started
To get started, run the system-shell:
```bash
eval $(docker run -it --rm ndslabs/system-shell usage docker)
```
Docker will download and run the system-shell, which contains everything you'll need to get started.

Run the following command to start a single-node development Kubernetes cluster:
```bash
kube-up.sh
```

To verify that your cluster is up and running, you can run:
```bash
kubectl get pods
```

## Starting Clowder
Running the start script will bring up clowder. Be sure to give it a space-separated list of plugins / extractors that you would like to bring up:
```bash
./start-clowder.sh [plugin1] [plugin2] ...
```

Accepted plugin values can be found below:
* elasticsearch
* speech2text
* plantcv
* image-metadata
* audio-preview
* image-preview
* video-preview
* pdf-preview

NOTE: Specifying one or more extractors automatically starts RabbitMQ. Otherwise, RabbitMQ will not be started.

## Stopping Clowder
Simply run the stop script to stop clowder:
```bash
./stop-clowder.sh
```

You can optionally specify the `-m` parameter to stop everything but MongoDB.

This can be useful for preserving credentials, so that you do not need to re-signup for Clowder whenever you restart things.
