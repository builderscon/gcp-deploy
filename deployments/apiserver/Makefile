CLOUDSQL_FILES= \
	cloudsql/address \
	cloudsql/client-cert.pem \
	cloudsql/client-key.pem\
	cloudsql/password \
	cloudsql/server-ca.pem

cloudsql-secret: make-cloudsql-secret.sh $(CLOUDSQL_FILES)
	@./make-cloudsql-secret.sh | kubectl apply -f -

deploy: deployment.yaml
	@$(MAKE) cloudsql-secret
	@kubectl apply -f deployment.yaml