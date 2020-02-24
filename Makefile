PWD := $(shell pwd)

.PHONY: setup
setup:
	cd ./terraform
	docker run -i --rm --name ontherocks -e MONGOPASSWORD=${MONGODB_PASSWORD} -e MONGOROOTPASSWORD=${MONGODB_ROOT_PASSWORD} -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} -v ${PWD}/terraform/export:/kube -v ${PWD}/terraform:/terraform evalsocket/ontherocks make create

.PHONY: teardown
teardown:
	cd ./terraform
	docker run -i --rm --name ontherocks -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}  -v $(PWD)/terraform:/terraform evalsocket/ontherocks make teardown

.PHONY: clean
clean:
	@git status --ignored --short | grep '^!! ' | sed 's/!! //' | xargs rm -rf

