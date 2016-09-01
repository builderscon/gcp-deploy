CLOUDSQL_FILES= \
	cloudsql/address \
	cloudsql/client-cert.pem \
	cloudsql/client-key.pem\
	cloudsql/password \
	cloudsql/server-ca.pem

MAILGUN_FILES= \
	mailgun/mailgun.json

cloudsql-secret: make-cloudsql-secret.sh $(CLOUDSQL_FILES)
	@./make-cloudsql-secret.sh | kubectl apply -f -

mailgun-secret: make-mailgun-secret.sh $(MAILGUN_FILES)
	@./make-mailgun-secret.sh | kubectl apply -f -

deploy: deployment.yaml
	@$(MAKE) cloudsql-secret
	@$(MAKE) mailgun-secret
	@kubectl apply -f deployment.yaml