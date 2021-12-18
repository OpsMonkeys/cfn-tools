.DEFAULT_GOAL := help
SHA := latest
TAG := latest
GIT_TAG = $(shell git describe --tags $(git rev-list --tags --max-count=1) | sed s/v//g)
PACKAGE_VERSION = $(shell cat package.json| jq -r '.version')
IMAGE_TAG := ${DOCKER_REGISTRY_URL}/library/cfn-tools

build: ## Build the docker container and tag as latest
	docker build -t ${IMAGE_TAG}:${TAG} .
.PHONY: build

shell: build ## Build the docker container and then run in interaction mode
	docker run -it ${IMAGE_TAG}:${TAG} /bin/bash
.PHONY: shell

push: ## Push the docker container to registry
	docker push ${IMAGE_TAG}:${TAG}
.PHONY: push

tag: ## Tag the docker image
	docker tag ${IMAGE_TAG}:${SHA} ${IMAGE_TAG}:${TAG}
.PHONY: tag

grype: build ## Runs grype locally - you need to have it installed first (https://github.com/anchore/grype)
	grype ${IMAGE_TAG}:${TAG}
.PHONY: grype

hadolint: ## Runs hadolint locally - you need to have it installed first (https://github.com/hadolint/hadolint)
	hadolint Dockerfile
.PHONY: hadolint

check-version: ## Checks for the required version bump
	@echo "\033[36m"Checking Version"\033[0m"; \
	if [ "${GIT_TAG}" == "${PACKAGE_VERSION}" ]; then \
	echo "\033[0;31mVersion ${PACKAGE_VERSION} is equal to current tag ${GIT_TAG}, please update it!\033[0m"; \
	else \
	echo "\033[0;32mVersion ${PACKAGE_VERSION} is not equal to current tag ${GIT_TAG}, good to go\033[0m"; \
	fi
	@echo "\033[36m"Version Check Complete"\033[0m"
.PHONY: check-version

prepare-pr: hadolint build grype check-version ## Runs grype, and hadolint to check for issues with container before your PR
	@echo "\033[36m"Done Running PR Checks"\033[0m"
.PHONY: prepare-pr

help: ## show this usage
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
.PHONY: help
