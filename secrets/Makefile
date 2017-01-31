MYSQL_FILES=$(wildcard mysql/*)

.PHONY:	make-secret $(MYSQL_FILES)

make-secret:
	kubectl create secret generic $(SECRET_NAME) -o json --dry-run $(ARGS) | kubectl apply -f -

$(MYSQL_FILES):
	$(eval ARGS :=$(ARGS) --from-file=$@)

mysql: $(MYSQL_FILES)
	@$(MAKE) make-secret SECRET_NAME=$@ ARGS="$(ARGS)"
