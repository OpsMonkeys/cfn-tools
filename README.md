# CFN Build Container

## Summary

This repo contains the dockerfile for my CFN Build Container. This is a lightweight container based off amazon/aws-cli (https://hub.docker.com/r/amazon/aws-cli) that contains all the tools needed to provision work with Cloudformation, and other tools.
Includes:
AWS CLI
CFN DOCS https://pypi.org/project/cloudformation-docs/
CFN GUARD https://github.com/aws-cloudformation/cloudformation-guard
CFN LINT https://github.com/aws-cloudformation/cfn-lint
CFN NAG https://github.com/stelligent/cfn_nag
CHECKOV https://github.com/bridgecrewio/checkov
HADOLINT https://github.com/hadolint/hadolint
REVIEWDOG https://github.com/reviewdog/reviewdog
RUBOCOP https://github.com/rubocop/rubocop
YQ https://github.com/kislyuk/yq

This container gets used locally, and in CI to make sure all build processes use same environment setup.

### How to work with the repo

This is a pretty basic repo that contains the Dockerfile, a simple entry script, and the Makefile.
Make your adjustments to the dockerfile and then use the make commands to help build and test your changes.
You will need to set a DOCKER_REGISTRY_URL environment variable

`make build` = Will build the container for you

`make shell` = Will build the container and then run the container in interactive mode

`make push` = Will push the built container to your registry

`make tag` = Will tag the image

`make help` = Will list the help screen for the makefile


### PR Checks and Github Actions

This repo has a few different Github Actions that are also running.

Anchore - This is the container vulnerability scanning engine, that can help identify container issues. https://github.com/anchore/scan-action
Hadolint - This is a quick check for proper Dockerfile conventions and best practices
Docker_build_push - This builds and publishes a new image to Dockerhub https://hub.docker.com/r/drkrazy/cfn-tools based off a github release tag