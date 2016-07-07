.PHONY:

compclean:
	@$(MAKE) -C images/$(APPNAME) clean

docker:
	@$(MAKE) -C images/$(APPNAME) docker DEBUG=$(DEBUG)

publish:
	@$(MAKE) -C images/$(APPNAME) publish DEBUG=$(DEBUG)

gke-deploy:
	@$(MAKE) -C deployments/$(APPNAME) deploy

%-clean:
	@echo "* Cleaning..."
	@$(MAKE) compclean APPNAME=$(patsubst %-clean,%,$@) DEBUG=$(DEBUG)

%-docker:
	@echo "* Building docker image..."
	@$(MAKE) docker APPNAME=$(patsubst %-docker,%,$@) DEBUG=$(DEBUG)

%-publish:
	@echo "* Publishing docker image..."
	@$(MAKE) publish APPNAME=$(patsubst %-publish,%,$@) DEBUG=$(DEBUG)

%-gke-deploy:
	@echo "* Deploying to GKE..."
	@$(MAKE) gke-deploy APPNAME=$(patsubst %-gke-deploy,%,$@) DEBUG=$(DEBUG)

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

slackbot:
	@$(MAKE) -j 6 slackbot-docker DEBUG=$(DEBUG)
	@$(MAKE) -j 6 slackbot-publish DEBUG=$(DEBUG)
	@$(MAKE) slackbot-gke-deploy DEBUG=$(DEBUG)

