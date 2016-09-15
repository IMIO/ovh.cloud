build:
	docker build -t jfroche/ovh-py .

check-project:
ifndef PROJECT
	$(error PROJECT variable is undefined)
endif

list-instances: check-project
	@docker run -ti --rm -v $(PWD)/ovh.conf:/code/ovh.conf -v $(PWD)/bin:/code/bin jfroche/ovh-py python /code/bin/instance.py list --project $(PROJECT)

list-ssh-keys: check-project
	@docker run -ti --rm -v $(PWD)/ovh.conf:/code/ovh.conf -v $(PWD)/bin:/code/bin jfroche/ovh-py python /code/bin/ssh-keys.py list --project $(PROJECT)

remove-instances: check-project
	@docker run -ti --rm -v $(PWD)/ovh.conf:/code/ovh.conf -v $(PWD)/bin:/code/bin jfroche/ovh-py python /code/bin/instance.py remove-all --project $(PROJECT)

create-project: check-project
	@docker run -ti --rm -v $(PWD)/ovh.conf:/code/ovh.conf -v $(PWD)/bin:/code/bin jfroche/ovh-py python /code/bin/project.py create --project $(PROJECT)

list-projects:
	@docker run -ti --rm -v $(PWD)/ovh.conf:/code/ovh.conf -v $(PWD)/bin:/code/bin jfroche/ovh-py python /code/bin/project.py list

remove-project: check-project
	@docker run -ti --rm -v $(PWD)/ovh.conf:/code/ovh.conf -v $(PWD)/bin:/code/bin jfroche/ovh-py python /code/bin/project.py remove --project $(PROJECT)

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
