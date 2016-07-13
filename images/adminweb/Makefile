BUILDER_IMAGE=octav/adminweb-builder
REPOSITORY_HOST=asia.gcr.io
PROJECT_ID=$(shell gcloud config list 2>&1 | grep 'project = ' | sed -e 's/project = //')
APPNAME=adminweb
APPDIR=$(CURDIR)/$(APPNAME)
CONFIG_NAME=octav-dev

$(APPDIR):
	git clone git@github.com:builderscon/admin.builderscon.io.git $(APPDIR)

$(CURDIR)/cpanfile: $(APPDIR)/cpanfile
	cp $(APPDIR)/cpanfile $(CURDIR)/cpanfile

build-local-lib:
	docker build -f Dockerfile.build -t octav/adminweb-builder .

$(CURDIR)/perl.tar.gz: $(CURDIR)/adminweb-builder.cid
	docker cp `cat adminweb-builder.cid`:/perl.tar.gz .

$(CURDIR)/adminweb-local-lib.tar.gz: $(CURDIR)/adminweb-builder.cid
	docker cp `cat adminweb-builder.cid`:/adminweb-local-lib.tar.gz .

$(CURDIR)/adminweb-builder.cid: build-local-lib
	@-rm adminweb-builder.cid
	docker run --cidfile adminweb-builder.cid $(BUILDER_IMAGE)

$(CURDIR)/adminweb.tar.gz: $(wildcard $(APPDIR)/**/*)
	tar -C $(APPDIR)/.. \
		--exclude adminweb/local \
		--exclude adminweb/tmp \
		--exclude adminweb/.git \
		-cvzf $(CURDIR)/adminweb.tar.gz $(shell basename $(APPDIR))

docker: $(CURDIR)/cpanfile $(CURDIR)/adminweb.tar.gz $(CURDIR)/adminweb-local-lib.tar.gz $(CURDIR)/perl.tar.gz 
	docker build -t octav/adminweb .

latest:
	@make $(APPDIR)
	@pushd $(APPDIR) && git pull && popd

gcloud-config:
	@echo "Activating configuration $(CONFIG_NAME)"
	@gcloud config configurations activate $(CONFIG_NAME)

tag:
	$(eval TAG := $(shell cd $(APPDIR) && git describe --tags >& /dev/null))
ifeq ($(TAG), )
	$(eval TAG := $(shell cd $(APPDIR) && git log -1 --pretty=format:%h))
endif
	$(eval TAG := $(TAG)-$(shell shasum adminweb.tar.gz | cut -c1-7)-$(shell shasum adminweb-local-lib.tar.gz | cut -c1-7)-$(shell shasum Dockerfile | cut -c1-7))
	$(eval IMAGE_NAME_BASE :=$(REPOSITORY_HOST)/$(PROJECT_ID)/$(APPNAME))
	$(eval IMAGE_NAME_LATEST :=$(IMAGE_NAME_BASE):latest)
	$(eval IMAGE_NAME :=$(IMAGE_NAME_BASE):$(TAG))
	@echo "Using tag '$(TAG)'"

publish: latest tag docker gcloud-config
	@echo "Publishing [ $(IMAGE_NAME) ]"
	@docker tag octav/$(APPNAME) $(IMAGE_NAME)
	@echo " --> pushing $(IMAGE_NAME)..."
	@docker tag $(IMAGE_NAME) $(IMAGE_NAME_LATEST)
	@gcloud docker push $(IMAGE_NAME)
	@gcloud docker push $(IMAGE_NAME_LATEST)

clean:
	@-rm $(CURDIR)/adminweb.tar.gz