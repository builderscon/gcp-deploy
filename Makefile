DEBUG=

.PHONY: $(APPNAME)

docker:
	@$(MAKE) -C images/$(APPNAME) docker DEBUG=$(DEBUG)

publish:
	@$(MAKE) -C images/$(APPNAME) publish DEBUG=$(DEBUG)

deploy:
	@$(MAKE) -C deployments/$(APPNAME) deploy

%-docker:
	@echo "* Building docker image..."
	@$(MAKE) docker APPNAME=$(patsubst %-docker,%,$@) DEBUG=$(DEBUG)

%-publish:
	@echo "* Publishing docker image..."
	@$(MAKE) publish APPNAME=$(patsubst %-publish,%,$@)
