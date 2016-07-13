APPNAME=nginx
REPOSITORY_HOST=asia.gcr.io
PROJECT_ID=$(shell gcloud config list 2>&1 | grep 'project = ' | sed -e 's/project = //')

TAG:=$(shell date +"%Y%m%d.%H%M%S")
IMAGE_NAME:=$(REPOSITORY_HOST)/$(PROJECT_ID)/$(APPNAME):$(TAG)

docker:
	docker build -t octav/nginx .

tag:
ifeq ($(TAG), )
        $(eval TAG := $(shell cd $(APPDIR) && git log -1 --pretty=format:%h))
endif
        $(eval TAG := $(TAG)-$(shell shasum Dockerfile | cut -c1-7))-$(shell shasum Makefile | cut -c1-7))-$(shell shasum mime.types | cut -c1-7))
        $(eval IMAGE_NAME_BASE :=$(REPOSITORY_HOST)/$(PROJECT_ID)/$(APPNAME))
        $(eval IMAGE_NAME_LATEST :=$(IMAGE_NAME_BASE):latest)
        $(eval IMAGE_NAME :=$(IMAGE_NAME_BASE):$(TAG))
        @echo "Using tag '$(TAG)'"

publish: tag
        @echo "Publishing [ $(IMAGE_NAME) ]"
        @docker tag octav/$(APPNAME) $(IMAGE_NAME)
        @echo " --> pushing $(IMAGE_NAME)..."
        @docker tag $(IMAGE_NAME) $(IMAGE_NAME_LATEST)
        @gcloud docker push $(IMAGE_NAME)
        @gcloud docker push $(IMAGE_NAME_LATEST)

clean:
	@-rm nginx
