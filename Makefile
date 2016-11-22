.PHONY: ingress

switch-cluster:
	gcloud container clusters get-credentials $(CLUSTER)

compclean:
	@$(MAKE) -C images/$(APPNAME) clean

docker:
	@$(MAKE) -C images/$(APPNAME) docker DEBUG=$(DEBUG)

publish:
	@$(MAKE) -C images/$(APPNAME) publish DEBUG=$(DEBUG)

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

%-deploy:
	@echo "* Deploying to GKE..."
	@$(MAKE) deploy APPNAME=$(patsubst %-deploy,%,$@) DEBUG=$(DEBUG)

%-ingress:
	@echo "* Deploying ingress..."
	@$(MAKE) ingress INGRESS_NAME=$(patsubst %-ingress,%,$@)

slackbot-clean:
	@$(MAKE) acmebot-clean 
	@$(MAKE) acmebot-k8s-clean 
	@$(MAKE) deploybot-clean 
	@$(MAKE) deploybot-k8s-clean 
	@$(MAKE) slackgw-clean 
	@$(MAKE) slackrouter-clean 

slackbot-docker:
	@$(MAKE) acmebot-docker DEBUG=$(DEBUG)
	@$(MAKE) acmebot-k8s-docker DEBUG=$(DEBUG)
	@$(MAKE) deploybot-docker DEBUG=$(DEBUG)
	@$(MAKE) deploybot-k8s-docker DEBUG=$(DEBUG)
	@$(MAKE) slackgw-docker DEBUG=$(DEBUG)
	@$(MAKE) slackrouter-docker DEBUG=$(DEBUG)

slackbot-publish:
	@$(MAKE) acmebot-publish DEBUG=$(DEBUG)
	@$(MAKE) acmebot-k8s-publish DEBUG=$(DEBUG)
	@$(MAKE) deploybot-publish DEBUG=$(DEBUG)
	@$(MAKE) deploybot-k8s-publish DEBUG=$(DEBUG)
	@$(MAKE) slackgw-publish DEBUG=$(DEBUG)
	@$(MAKE) slackrouter-publish DEBUG=$(DEBUG)

deployment:
	@$(MAKE) $(DEPLOYMENT)-clean DEBUG=$(DEBUG)
	@$(MAKE) $(DEPLOYMENT)-docker DEBUG=$(DEBUG)
	@$(MAKE) $(DEPLOYMENT)-publish DEBUG=$(DEBUG)

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

vanity-redirector:
	@$(MAKE) deployment DEBUG=$(DEBUG) DEPLOYMENT=vanity-redirector
