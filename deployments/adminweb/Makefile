nginx-conf: nginx.conf
	SECRET_NAME=nginx-admin-builderscon-io ./make-nginx-secret.sh | kubectl apply -f -

services: services.yaml
	kubectl apply -f services.yaml

deploy: deployment.yaml
	$(MAKE) nginx-conf
	$(MAKE) services
	kubectl apply -f deployment.yaml