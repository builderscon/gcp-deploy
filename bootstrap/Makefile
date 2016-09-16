FILES=config.json
	
deploy: $(FILES)
	@./bootstrap.sh
	@make -C .. kube-lego-deploy
	@make -C .. redis-deploy
	@make -C .. apiserver-deploy
	@make -C .. adminweb-deploy
	@make -C .. confweb-deploy
	@make -C .. builderscon-ingress
	@make -C .. adminweb-ingress