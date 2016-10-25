builderscon:
	kubectl apply -f builderscon.io.yaml
	./hcupdate.sh builderscon

adminweb:
	kubectl apply -f admin.builderscon.io.yaml
	./hcupdate.sh adminweb

apiserver:
	kubectl apply -f api.builderscon.io.yaml
	./hcupdate.sh apiserver

vanity-redirector:
	kubectl apply -f vanity-redirector.yaml
	./hcupdate.sh vanity-redirector
