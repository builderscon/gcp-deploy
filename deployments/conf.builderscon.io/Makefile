nginx-conf: nginx.conf
	SECRET_NAME=nginx-conf-builderscon-io ./make-nginx-secret.sh | kubectl apply -f -

deploy:
	$(MAKE) nginx-conf
	kubectl apply -f deployment.yaml