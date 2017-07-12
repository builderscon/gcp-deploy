DEPLOY_ROOT=../..
APPNAME=apiserver
REPOSITORY_HOST=asia.gcr.io
PROJECT_ID=$(shell gcloud config list 2>&1 | grep 'project = ' | sed -e 's/project = //')
CONFIG_NAME=octav-dev

APPDIR=$(shell go list -f '{{ .Dir }}' github.com/builderscon/octav/octav)

SRC_FILES = $(wildcard $(APPDIR)/*.go $(APPDIR)/validator/*.go $(APPDIR)/client/*.go $(APPDIR)/db/*.go $(APPDIR)/model/*.go)

tag:
	$(eval TAG := $(shell cd $(APPDIR) && git describe --tags >& /dev/null))
ifeq ($(TAG), )
	$(eval TAG := $(shell cd $(APPDIR) && git log -1 --pretty=format:%h))
endif
	$(eval TAG := $(TAG)-$(shell cat Dockerfile | shasum | cut -c1-7))
ifeq ($(DEBUG), 1)
	$(eval TAG := $(TAG)-debug)
endif
	$(eval IMAGE_NAME_BASE :=$(REPOSITORY_HOST)/$(PROJECT_ID)/$(APPNAME))
	$(eval IMAGE_NAME_LATEST :=$(IMAGE_NAME_BASE):latest)
	$(eval IMAGE_NAME :=$(IMAGE_NAME_BASE):$(TAG))
	@echo "Using tag '$(TAG)'"

$(CURDIR)/$(APPNAME): $(APPDIR)
ifeq ($(DEBUG), 1)
	cd $(APPDIR) && \
	GOOS=linux GOARCH=amd64 go build -tags="gcp debug0" -o $(CURDIR)/$(APPNAME) cmd/octav/octav.go
else
	cd $(APPDIR) && \
	GOOS=linux GOARCH=amd64 go build -o $(CURDIR)/$(APPNAME) -tags gcp cmd/octav/octav.go
endif

$(APPNAME): $(CURDIR)/$(APPNAME)

docker: $(CURDIR)/$(APPNAME)
	docker build -t octav/$(APPNAME) .

gcloud-config:
	@echo "Activating configuration $(CONFIG_NAME)"
	@gcloud config configurations activate $(CONFIG_NAME)

publish: gcloud-config tag $(APPNAME)
	@echo "Publishing [ $(IMAGE_NAME) ]"
	@docker tag octav/$(APPNAME) $(IMAGE_NAME)
	@echo " --> pushing $(IMAGE_NAME)..."
	@docker tag $(IMAGE_NAME) $(IMAGE_NAME_LATEST)
	@docker push $(IMAGE_NAME)
	@docker push $(IMAGE_NAME_LATEST)

update-image: tag
	@echo "Updating charts/builderscon/charts/apiserver/values.yaml file to use image $(IMAGE_NAME)..."
	@perl -i -pe 's{ContainerTag: .+$$}{ContainerTag: $(TAG)}' $(DEPLOY_ROOT)/charts/builderscon/charts/$(APPNAME)/values.yaml

clean:
	@-rm $(APPNAME)
