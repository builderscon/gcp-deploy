APPNAME=slackgw
REPOSITORY_HOST=asia.gcr.io
PROJECT_ID=$(shell gcloud config list 2>&1 | grep 'project = ' | sed -e 's/project = //')

APPDIR=$(shell go list -f '{{ .Dir }}' github.com/lestrrat/go-slackgw)

tag:
	$(eval TAG := $(shell cd $(APPDIR) && git describe --tags >& /dev/null))
ifeq ($(TAG), )
	$(eval TAG := $(shell cd $(APPDIR) && git log -1 --pretty=format:%h))
endif
	$(eval TAG := $(TAG)-$(shell shasum ca-certificates.crt | cut -c1-7))
ifeq ($(DEBUG), 1)
	$(eval TAG := $(TAG)-debug)
endif
	$(eval IMAGE_NAME_BASE :=$(REPOSITORY_HOST)/$(PROJECT_ID)/$(APPNAME))
	$(eval IMAGE_NAME_LATEST :=$(IMAGE_NAME_BASE):latest)
	$(eval IMAGE_NAME :=$(IMAGE_NAME_BASE):$(TAG))
	@echo "Using tag '$(TAG)'"

$(CURDIR)/$(APPNAME):
ifeq ($(DEBUG), 1)
	cd $(APPDIR) && \
	GOOS=linux GOARCH=amd64 go build -tags debug0 -o $(CURDIR)/$(APPNAME) .
	
else
	cd $(APPDIR) && \
	GOOS=linux GOARCH=amd64 go build -o $(CURDIR)/$(APPNAME) .
endif

$(APPNAME): $(CURDIR)/$(APPNAME)

docker: $(CURDIR)/$(APPNAME)
	docker build -t octav/$(APPNAME) .

publish: tag $(APPNAME)
	@echo "Publishing [ $(IMAGE_NAME) ]"
	@docker tag octav/$(APPNAME) $(IMAGE_NAME)
	@echo " --> pushing $(IMAGE_NAME)..."
	@docker tag $(IMAGE_NAME) $(IMAGE_NAME_LATEST)
	@gcloud docker push $(IMAGE_NAME)
	@gcloud docker push $(IMAGE_NAME_LATEST)

clean:
	@-rm $(APPNAME)
