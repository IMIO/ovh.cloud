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
