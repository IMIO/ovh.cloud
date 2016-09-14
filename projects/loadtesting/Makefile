terraform:
	wget --quiet https://releases.hashicorp.com/terraform/0.7.3/terraform_0.7.3_linux_amd64.zip
	unzip terraform_0.7.3_linux_amd64.zip
	rm terraform_0.7.3_linux_amd64.zip

init: terraform
	./terraform remote config -backend=consul -backend-config="address=consul.imio.be:80" -backend-config="path=tf-loadtesting"
	./terraform remote pull

update:
	@./terraform get -update=true

plan: init update
	./terraform plan -out 'plan' -module-depth=-1  .

show: plan
	@./terraform show plan

nova-debug:
	source openrc.sh
	docker run -v $(PWD)/openrc.sh:/root/openrc.sh -i -t chamerling/openstack-client /bin/bash

apply: init update
	@./terraform apply -refresh=true plan && terraform remote push

format:
	find . -maxdepth 2 -name "*.tf" -exec ./terraform fmt {} \;
