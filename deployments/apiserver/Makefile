MAILGUN_FILES= \
	mailgun/mailgun.json

TWITTER_FILES= \
	twitter/twitter.json

mailgun-secret: make-mailgun-secret.sh $(MAILGUN_FILES)
	@./make-mailgun-secret.sh | kubectl apply -f -

twitter-secret: make-twitter-secret.sh $(MAILGUN_FILES)
	@./make-twitter-secret.sh | kubectl apply -f -

deploy: deployment.yaml
	@$(MAKE) -C ../../secrets mysql
	@$(MAKE) mailgun-secret
	@$(MAKE) twitter-secret
	@kubectl apply -f deployment.yaml
	@kubectl apply -f services.yaml