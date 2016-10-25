REPOSITORY_HOST=asia.gcr.io
PROJECT_ID=$(shell gcloud config list 2>&1 | grep 'project = ' | sed -e 's/project = //')
APPNAME=vanity-redirector
APPDIR=$(CURDIR)/$(APPNAME)
CONFIG_NAME=octav-dev

docker: app.psgi cpanfile run.sh
	docker build -t octav/vanity-redirector .

gcloud-config:
	@echo "Activating configuration $(CONFIG_NAME)"
	@gcloud config configurations activate $(CONFIG_NAME)

tag:
	$(eval TAG := $(shell shasum run.sh | cut -c1-7)-$(shell shasum cpanfile | cut -c1-7)-$(shell shasum app.psgi | cut -c1-7)-$(shell shasum Dockerfile | cut -c1-7))
	$(eval IMAGE_NAME_BASE :=$(REPOSITORY_HOST)/$(PROJECT_ID)/$(APPNAME))
	$(eval IMAGE_NAME_LATEST :=$(IMAGE_NAME_BASE):latest)
	$(eval IMAGE_NAME :=$(IMAGE_NAME_BASE):$(TAG))
	@echo "Using tag '$(TAG)'"

publish: latest tag docker gcloud-config
	@echo "Publishing [ $(IMAGE_NAME) ]"
	@docker tag octav/$(APPNAME) $(IMAGE_NAME)
	@echo " --> pushing $(IMAGE_NAME)..."
	@docker tag $(IMAGE_NAME) $(IMAGE_NAME_LATEST)
	@gcloud docker -- push $(IMAGE_NAME)
	@gcloud docker -- push $(IMAGE_NAME_LATEST)

clean:

latest:


