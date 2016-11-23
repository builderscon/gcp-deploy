authmap: authmap.txt
	perl -anE 'system("htpasswd", "-nb", $$F[0], $$F[1])' authmap.txt | perl -ne 'print unless /^$$/' > authmap
	
	SECRET_NAME=authmap-admin-builderscon-io ./make-authmap-secret.sh | kubectl apply -f -

nginx-conf: nginx.conf
	SECRET_NAME=nginx-admin-builderscon-io ./make-nginx-secret.sh | kubectl apply -f -

services: services.yaml
	kubectl apply -f services.yaml

config: config.yaml
	kubectl apply -f config.yaml

octav: octav.json
	SECRET_NAME=octav-client-id ./make-octav-client-id-secret.sh | kubectl apply -f -

deploy: deployment.yaml
	$(MAKE) config
	$(MAKE) authmap
	$(MAKE) nginx-conf
	$(MAKE) services
	kubectl apply -f deployment.yaml