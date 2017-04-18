DEPLOY_ROOT=../..
APPNAME=redis-cluster
REPOSITORY_HOST=asia.gcr.io
PROJECT_ID=$(shell gcloud config list 2>&1 | grep 'project = ' | sed -e 's/project = //')
CONFIG_NAME=octav-dev

tag:
	$(eval TAG := $(shell cat Dockerfile | shasum | cut -c1-7))
	$(eval IMAGE_NAME_BASE :=$(REPOSITORY_HOST)/$(PROJECT_ID)/$(APPNAME))
	$(eval IMAGE_NAME_LATEST :=$(IMAGE_NAME_BASE):latest)
	$(eval IMAGE_NAME :=$(IMAGE_NAME_BASE):$(TAG))
	@echo "Using tag '$(TAG)'"

docker: 
	docker build -t octav/$(APPNAME) .

gcloud-config:
	@echo "Activating configuration $(CONFIG_NAME)"
	@gcloud config configurations activate $(CONFIG_NAME)

publish: gcloud-config tag
	@echo "Publishing [ $(IMAGE_NAME) ]"
	@docker tag octav/$(APPNAME) $(IMAGE_NAME)
	@echo " --> pushing $(IMAGE_NAME)..."
	@docker tag $(IMAGE_NAME) $(IMAGE_NAME_LATEST)
	@gcloud docker -- push $(IMAGE_NAME)
	@gcloud docker -- push $(IMAGE_NAME_LATEST)

update-image: tag
	@echo "Updating deployment.yaml file to use image $(IMAGE_NAME)..."
	@perl -i -pe 's{image: $(REPOSITORY_HOST)/$(PROJECT_ID)/$(APPNAME):.+$$}{image: $(IMAGE_NAME)}' $(DEPLOY_ROOT)/deployments/$(APPNAME)/deployment.yaml

clean:
	@echo "Nothing to do"
