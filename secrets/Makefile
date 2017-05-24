MYSQL_FILES=$(wildcard mysql/*)
REDIS_FILES=$(wildcard redis/*)
YOUTUBE_FILES=$(wildcard youtube/*)
GITHUB_FILES=$(wildcard github/*)
FLASK_FILES=$(wildcard flask/*)
FACEBOOK_FILES=$(wildcard facebook/*)
TWITTER_FILES=$(wildcard twitter/*)
MAILGUN_FILES=$(wildcard mailgun/*)

.PHONY:	make-secret $(MYSQL_FILES) $(REDIS_FILES) $(YOUTUBE_FILES) $(GITHUB_FILES) $(FLASK_FILES) $(FACEBOOK_FILES) $(TWITTER_FILES) $(MAILGUN_FILES)

make-secret:
	kubectl create secret generic $(SECRET_NAME) -o json --dry-run $(ARGS) | kubectl apply -f -

$(MYSQL_FILES):
	$(eval ARGS :=$(ARGS) --from-file=$@)

$(REDIS_FILES):
	$(eval ARGS :=$(ARGS) --from-file=$@)

$(YOUTUBE_FILES):
	$(eval ARGS :=$(ARGS) --from-file=$@)

$(GITHUB_FILES):
	$(eval ARGS :=$(ARGS) --from-file=$@)

$(FLASK_FILES):
	$(eval ARGS :=$(ARGS) --from-file=$@)

$(FACEBOOK_FILES):
	$(eval ARGS :=$(ARGS) --from-file=$@)

$(TWITTER_FILES):
	$(eval ARGS :=$(ARGS) --from-file=$@)

$(MAILGUN_FILES):
	$(eval ARGS :=$(ARGS) --from-file=$@)

mysql: $(MYSQL_FILES)
	@$(MAKE) make-secret SECRET_NAME=$@ ARGS="$(ARGS)"

redis: $(REDIS_FILES)
	@$(MAKE) make-secret SECRET_NAME=$@ ARGS="$(ARGS)"

youtube: $(YOUTUBE_FILES)
	@$(MAKE) make-secret SECRET_NAME=$@ ARGS="$(ARGS)"

github: $(GITHUB_FILES)
	@$(MAKE) make-secret SECRET_NAME=$@ ARGS="$(ARGS)"

flask: $(FLASK_FILES)
	@$(MAKE) make-secret SECRET_NAME=$@ ARGS="$(ARGS)"

facebook: $(FACEBOOK_FILES)
	@$(MAKE) make-secret SECRET_NAME=$@ ARGS="$(ARGS)"

twitter: $(TWITTER_FILES)
	@$(MAKE) make-secret SECRET_NAME=$@ ARGS="$(ARGS)"

mailgun: $(MAILGUN_FILES)
	@$(MAKE) make-secret SECRET_NAME=$@ ARGS="$(ARGS)"

