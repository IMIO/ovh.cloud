DOCKER=/usr/bin/docker
build:
	$(DOCKER) build -t jfroche/ovh-py .

check-project:
ifndef PROJECT
	$(error PROJECT variable is undefined)
endif

ifdef FORMAT
CLI_FORMAT=--format $(FORMAT)
endif
list-instances: check-project
	$(DOCKER) run --rm -v $(shell pwd)/ovh.conf:/code/ovh.conf -v $(shell pwd)/bin:/code/bin jfroche/ovh-py python /code/bin/instance.py list --project $(PROJECT) $(CLI_FORMAT)

list-ssh-keys: check-project
	@$(DOCKER) run -ti --rm -v $(shell pwd)/ovh.conf:/code/ovh.conf -v $(shell pwd)/bin:/code/bin jfroche/ovh-py python /code/bin/ssh-keys.py list --project $(PROJECT)

remove-instances: check-project
	@$(DOCKER) run -ti --rm -v $(shell pwd)/ovh.conf:/code/ovh.conf -v $(shell pwd)/bin:/code/bin jfroche/ovh-py python /code/bin/instance.py remove-all --project $(PROJECT)

create-project: check-project
	@$(DOCKER) run -ti --rm -v $(shell pwd)/ovh.conf:/code/ovh.conf -v $(shell pwd)/bin:/code/bin jfroche/ovh-py python /code/bin/project.py create --project $(PROJECT)

list-projects:
	@$(DOCKER) run -ti --rm -v $(shell pwd)/ovh.conf:/code/ovh.conf -v $(shell pwd)/bin:/code/bin jfroche/ovh-py python /code/bin/project.py list

remove-project: check-project
	@$(DOCKER) run -ti --rm -v $(shell pwd)/ovh.conf:/code/ovh.conf -v $(shell pwd)/bin:/code/bin jfroche/ovh-py python /code/bin/project.py remove --project $(PROJECT)

list-networks: check-project
	@$(DOCKER) run -ti --rm -v $(shell pwd)/ovh.conf:/code/ovh.conf -v $(shell pwd)/bin:/code/bin jfroche/ovh-py python /code/bin/network.py list --project $(PROJECT)

remove-networks: check-project
	@$(DOCKER) run -ti --rm -v $(shell pwd)/ovh.conf:/code/ovh.conf -v $(shell pwd)/bin:/code/bin jfroche/ovh-py python /code/bin/network.py remove --project $(PROJECT) --id $(ID)

check-cluster:
ifndef CLUSTER
	$(error CLUSTER is undefined)
endif

debug:
	$(DOCKER) run --rm --volume $(SSH_AUTH_SOCK):/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent -e OS_AUTH_URL -e OS_PASSWORD -e OS_REGION_NAME -e OS_TENANT_NAME -e OS_USERNAME -v $(shell pwd):/code -ti jfroche/ovh-py bash

create-cluster: check-cluster
	$(DOCKER) run -ti --rm --volume $(SSH_AUTH_SOCK):/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent -e OS_AUTH_URL -e OS_PASSWORD -e OS_REGION_NAME -e OS_TENANT_NAME -e OS_USERNAME -v $(shell pwd):/code jfroche/ovh-py bin/cluster.py create $(CLUSTER)

list-cluster: check-cluster
	$(DOCKER) run --rm --volume $(SSH_AUTH_SOCK):/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent -e OS_AUTH_URL -e OS_PASSWORD -e OS_REGION_NAME -e OS_TENANT_NAME -e OS_USERNAME -v $(shell pwd):/code jfroche/ovh-py bin/cluster.py list $(CLUSTER)

remove-cluster: check-cluster
	$(DOCKER) run --rm --volume $(SSH_AUTH_SOCK):/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent -e OS_AUTH_URL -e OS_PASSWORD -e OS_REGION_NAME -e OS_TENANT_NAME -e OS_USERNAME -v $(shell pwd):/code jfroche/ovh-py bin/cluster.py remove $(CLUSTER)
