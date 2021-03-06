CONFIG=octav-dev
CLUSTER=builderscon-prd3

.PHONY: ingress force-switch-account download-secrets upload-secrets

switch-account:
	gcloud config configurations activate $(CONFIG)
	gcloud auth application-default login
	gcloud container clusters get-credentials $(CLUSTER) --zone asia-east1-a

cloudsql:
	@echo "Connecting to mysql..."
	@mysql -uoctav -h $(shell cat secrets/mysql/address) --password=$(shell cat secrets/mysql/password) --ssl-ca=secrets/mysql/server-ca.pem --ssl-cert=secrets/mysql/client-cert.pem --ssl-key=secrets/mysql/client-key.pem octav

compclean:
	@$(MAKE) -C images/$(APPNAME) clean

docker:
	@$(MAKE) -C images/$(APPNAME) docker DEBUG=$(DEBUG)

publish:
	@$(MAKE) -C images/$(APPNAME) publish DEBUG=$(DEBUG)

update-image:
	@$(MAKE) -C images/$(APPNAME) update-image DEBUG=$(DEBUG)

ingress:
	$(MAKE) -C ingress $(INGRESS_NAME)

%-clean:
	@echo "* Cleaning $(patsubst %-clean,%,$@)..."
	@$(MAKE) compclean APPNAME=$(patsubst %-clean,%,$@) DEBUG=$(DEBUG)

%-docker:
	@echo "* Building docker image..."
	@$(MAKE) docker APPNAME=$(patsubst %-docker,%,$@) DEBUG=$(DEBUG)

%-publish:
	@echo "* Publishing docker image..."
	@$(MAKE) publish APPNAME=$(patsubst %-publish,%,$@) DEBUG=$(DEBUG)

%-update-image:
	@echo "* Updating image in deployment..."
	@$(MAKE) update-image APPNAME=$(patsubst %-update-image,%,$@) DEBUG=$(DEBUG)

%-ingress:
	@echo "* Deploying ingress..."
	@$(MAKE) ingress INGRESS_NAME=$(patsubst %-ingress,%,$@)

deployment:
	@$(MAKE) $(DEPLOYMENT)-clean DEBUG=$(DEBUG)
	@$(MAKE) $(DEPLOYMENT)-docker DEBUG=$(DEBUG)
	@$(MAKE) $(DEPLOYMENT)-publish DEBUG=$(DEBUG)
	@$(MAKE) $(DEPLOYMENT)-update-image DEBUG=$(DEBUG)

slackbot:
	@$(MAKE) deployment DEBUG=$(DEBUG) DEPLOYMENT=slackbot

apiserver:
	@$(MAKE) deployment DEBUG=$(DEBUG) DEPLOYMENT=apiserver

adminweb:
	@$(MAKE) deployment DEBUG=$(DEBUG) DEPLOYMENT=adminweb

confweb:
	@$(MAKE) deployment DEBUG=$(DEBUG) DEPLOYMENT=confweb

mailer:
	@$(MAKE) deployment DEBUG=$(DEBUG) DEPLOYMENT=mailer

redis:
	@$(MAKE) deployment DEBUG=$(DEBUG) DEPLOYMENT=redis

vanity-redirector:
	@$(MAKE) deployment DEBUG=$(DEBUG) DEPLOYMENT=vanity-redirector

deploy:
	@if [ "$$(helm ls | grep builderscon | awk '{print $$1}')" == "builderscon" ]; then \
		echo "Upgrading helm release builderscon"; \
		helm upgrade builderscon $(HELM_ARGS) ./charts/builderscon; \
	else \
		echo "Installing helm release builderscon"; \
		helm install --name builderscon $(HELM_ARGS) ./charts/builderscon; \
	fi

download-secrets:
	@sh ./scripts/download-secrets.sh

upload-secrets:
	@sh ./scripts/upload-secrets.sh

