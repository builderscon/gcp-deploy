CONFIG=octav-dev
CLUSTER=builderscon-prd2

.PHONY: ingress force-switch-account

switch-account:
	gcloud config configurations activate $(CONFIG)
	gcloud auth application-default login
	gcloud container clusters get-credentials $(CLUSTER)

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
	@if [ "$$(helm ls | grep $(patsubst %-helm,%,$@) | awk '{print $$1}')" == "$(patsubst %-helm,%,$@)" ]; then \
		echo "Upgrading helm release $(patsubst %-helm,%,$@)"; \
		helm upgrade $(patsubst %-helm,%,$@) $(HELM_ARGS) ./charts/$(patsubst %-helm,%,$@); \
	else \
		echo "Installing helm release $(patsubst %-helm,%,$@)"; \
		helm install --name $(patsubst %-helm,%,$@) $(HELM_ARGS) ./charts/$(patsubst %-helm,%,$@); \
	fi
