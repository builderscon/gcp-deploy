# gcp-deploy

Deploy scripts, configurations, and other utilities

## TODO

* Make the step of updating deployment.yaml automatic, perhaps by generating the YAML document on the fly

## Authentication

```
gcloud auth login
```

## Deploying Slackbot

```shell
make slackbot-docker # builds docker images
make slackbot-publish # publishes docker images to GCP
```

Note the image name from `slackbot-publish` action, such as

```
asia.gcr.io/builderscon-1248/slackgw:6259541-18550cb-debug
```

Apply this image name to `deployments/slackbot/deployment.yaml`, then run

```shell
make slackbot-gke-deploy
```

## Deploying the API server

```shell
make apiserver
# If you want debug print, do this:
make apiserver DEBUG=1
```

This will do the following:

* call `make apiserver-clean`
* call `make apiserver-docker`
* call `make apiserver-publish`

The source code used in `apiserver-docker` is expected to be in `$GOPATH/octav/octav`

Note the image name from `apiserver-publish` action, such as

```
asia.gcr.io/builderscon-1248/apiserver:976bee7-debug
```

Apply this image name to `deployments/apiserver/deployment.yaml`, then run

```shell
make apiserver-gke-deploy
```

## Deploying conf.builderscon.io

```shell
make confweb
```

This will do the following:

* call `make confweb-clean`
* call `make confweb-docker`
* call `make confweb-publish`

The source code used in `confweb-docker` is expected to be in `images/confweb/conf.builderscon.io`

Note the image name from `confweb-publish` action, such as

```
asia.gcr.io/builderscon-1248/confweb:976bee7-12db830-87fd8d6-ad30e43
```

Apply this image name to `deployments/confweb/deployment.yaml`, then run

```shell
make confweb-gke-deploy
```

## Kubernetes

### minikube

`minikube` allows you to run kubernetes locally. Note that when yo udo this,
you are obviously missing some GCP components such as CloudSQL, GAE, 
PubSub, etc., so not everything will work.

#### Installation

Download the appropriate binary, install it under your PATH: https://github.com/kubernetes/minikube/releases

Also download kubectl if you haven't done so.

