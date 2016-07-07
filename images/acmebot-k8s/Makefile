APPNAME=acmebot-k8s
REPOSITORY_HOST=asia.gcr.io
PROJECT_ID=$(shell gcloud config list 2>&1 | grep 'project = ' | sed -e 's/project = //')

APPDIR=$(shell go list -f '{{ .Dir }}' github.com/builderscon/slackbot/acmebot-k8s)

tag:
	$(eval TAG := $(shell cd $(APPDIR) && git describe --tags >& /dev/null))
ifeq ($(TAG), )
	$(eval TAG := $(shell cd $(APPDIR) && git log -1 --pretty=format:%h))
endif
ifeq ($(DEBUG), 1)
	$(eval TAG := $(TAG)-debug)
endif
	$(eval IMAGE_NAME_BASE :=$(REPOSITORY_HOST)/$(PROJECT_ID)/$(APPNAME))
	$(eval IMAGE_NAME_LATEST :=$(IMAGE_NAME_BASE):latest)
	$(eval IMAGE_NAME :=$(IMAGE_NAME_BASE):$(TAG))
	@echo "Using tag '$(TAG)'"

$(CURDIR)/acmebot-k8s:
ifeq ($(DEBUG), 1)
	cd $(APPDIR) && \
	GOOS=linux GOARCH=amd64 go build -tags debug0 -o $(CURDIR)/acmebot-k8s .
else
	cd $(APPDIR) && \
	GOOS=linux GOARCH=amd64 go build -o $(CURDIR)/acmebot-k8s .
endif

acmebot-k8s: $(CURDIR)/acmebot-k8s

docker: $(CURDIR)/acmebot-k8s
	docker build -t octav/acmebot-k8s .

publish: tag acmebot-k8s
	@echo "Publishing [ $(IMAGE_NAME) ]"
	@docker tag octav/$(APPNAME) $(IMAGE_NAME)
	@echo " --> pushing $(IMAGE_NAME)..."
	@docker tag $(IMAGE_NAME) $(IMAGE_NAME_LATEST)
	@gcloud docker push $(IMAGE_NAME)
	@gcloud docker push $(IMAGE_NAME_LATEST)

clean:
	@-rm acmebot-k8s
