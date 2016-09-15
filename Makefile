build:
	docker build -t jfroche/ovh-py .

list-instances:
	@docker run -ti --rm -v $(PWD)/ovh.conf:/code/ovh.conf -v $(PWD)/bin:/code/bin jfroche/ovh-py python /code/bin/instance.py list --project loadtesting

list-ssh-keys:
	@docker run -ti --rm -v $(PWD)/ovh.conf:/code/ovh.conf -v $(PWD)/bin:/code/bin jfroche/ovh-py python /code/bin/ssh-keys.py list --project loadtesting

remove-instances:
	@docker run -ti --rm -v $(PWD)/ovh.conf:/code/ovh.conf -v $(PWD)/bin:/code/bin jfroche/ovh-py python /code/bin/instance.py remove-all --project loadtesting

create-project:
	@docker run -ti --rm -v $(PWD)/ovh.conf:/code/ovh.conf -v $(PWD)/bin:/code/bin jfroche/ovh-py python /code/bin/project.py create --project $(PROJECT)

list-projects:
	@docker run -ti --rm -v $(PWD)/ovh.conf:/code/ovh.conf -v $(PWD)/bin:/code/bin jfroche/ovh-py python /code/bin/project.py list

check-cluster:
ifndef CLUSTER
	$(error CLUSTER is undefined)
endif

debug:
	docker run --rm --volume $(SSH_AUTH_SOCK):/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent -e OS_AUTH_URL -e OS_PASSWORD -e OS_REGION_NAME -e OS_TENANT_NAME -e OS_USERNAME -v $(PWD):/code -ti jfroche/ovh-py bash

create-cluster: check-cluster
	docker run --rm --volume $(SSH_AUTH_SOCK):/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent -e OS_AUTH_URL -e OS_PASSWORD -e OS_REGION_NAME -e OS_TENANT_NAME -e OS_USERNAME -v $(PWD):/code jfroche/ovh-py bin/cluster.py create $(CLUSTER)

list-cluster: check-cluster
	docker run --rm --volume $(SSH_AUTH_SOCK):/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent -e OS_AUTH_URL -e OS_PASSWORD -e OS_REGION_NAME -e OS_TENANT_NAME -e OS_USERNAME -v $(PWD):/code jfroche/ovh-py bin/cluster.py list $(CLUSTER)

remove-cluster: check-cluster
	docker run --rm --volume $(SSH_AUTH_SOCK):/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent -e OS_AUTH_URL -e OS_PASSWORD -e OS_REGION_NAME -e OS_TENANT_NAME -e OS_USERNAME -v $(PWD):/code jfroche/ovh-py bin/cluster.py remove $(CLUSTER)
