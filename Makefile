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

deploy:
	@$(MAKE) -C deployments/$(APPNAME) deploy

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

%-deploy:
	@echo "* Deploying to GKE..."
	@$(MAKE) deploy APPNAME=$(patsubst %-deploy,%,$@) DEBUG=$(DEBUG)

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

apiserver-v2:
	@$(MAKE) deployment DEBUG=$(DEBUG) DEPLOYMENT=apiserver-v2

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
