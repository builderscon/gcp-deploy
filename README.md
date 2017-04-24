# gcp-deploy

Deploy scripts, configurations, and other utilities

# TODO

* Make the step of updating deployment.yaml automatic, perhaps by generating the YAML document on the fly

# Authentication

You must do this ONCE. (NOT every time, just once)

```
gcloud auth login
```

# DEPLOYING

1. If you need to create a Docker image, run `make $whatever DEBUG=1`
2. Modify deployments/$whatever/deployment.yaml. To point to the new image, use the specification show in previous step (`asia.gcr.io/....`). Tweak Kubernetes settings as necessary
3. Run `make $whatever-deploy`

## Deploying the API server

```shell
make apiserver
# If you want debug print, do this:
make apiserver DEBUG=1
```

The Go source code used is expected to be in `$GOPATH/octav/octav`

## Deploying conf.builderscon.io

```shell
make confweb
```

The source code used is expected to be in `images/confweb/conf.builderscon.io`. The above command will issue a `git pull` as necessary

## Deploying admin.builderscon.io

```shell
make adminweb
```

The source code used is expected to be in `images/adminweb/admin.builderscon.io`. The above command will issue a `git pull` as necessary

# Kubernetes

TODO: Hopefully make minikube work?

`minikube` allows you to run kubernetes locally. Note that when yo udo this,
you are obviously missing some GCP components such as CloudSQL, GAE, 
PubSub, etc., so not everything will work.

## Installation

Download the appropriate binary, install it under your PATH: https://github.com/kubernetes/minikube/releases

Also download kubectl if you haven't done so.

# Architecture

|-------------------|---------------------------------------------------------------|
| mysql.default.svc | ExternalName service that points to either mysql.local.svc    |
|                   | mysql.prod.svc                                                |
|-------------------|---------------------------------------------------------------|
| mysql.prod.svc    | ExternalName service that points to CloudSQL                  |
|-------------------|---------------------------------------------------------------|
| mysql.local.svc   | ExternalName service that points to 10.0.2.2 (IP address      |
|                   | assigned for VirtualBox's host machine)                       |
|-------------------|---------------------------------------------------------------|
