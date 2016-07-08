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

## Deploying conf.builderscon.io

```shell
make confweb-docker
make confweb-publish
```

Note the image name from `confweb-publish` action, such as

```
asia.gcr.io/builderscon-1248/confweb:976bee7-12db830-87fd8d6-ad30e43
```

Apply this image name to `deployments/confweb/deployment.yaml`, then run

```shell
make confweb-gke-deploy
```

