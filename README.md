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

```shell
Usage:
  make <target>

Targets:
  build       Build the docker container and tag as latest
  shell       Build the docker container and then run in interaction mode
  push        Push the docker container to registry
  tag         Tag the docker image
  grype       Runs grype locally - you need to have it installed first (https://github.com/anchore/grype)
  hadolint    Runs hadolint locally - you need to have it installed first (https://github.com/hadolint/hadolint)
  prepare-pr  Runs grype, and hadolint to check for issues with container before your PR
  help        show this usage
  
```

### PR Checks and Github Actions

This repo has a few different Github Actions that are also running.

Anchore - This is the container vulnerability scanning engine, that can help identify container issues. https://github.com/anchore/scan-action

Hadolint - This is a quick check for proper Dockerfile conventions and best practices

Docker_build_push - This builds and publishes a new image to Dockerhub https://hub.docker.com/r/drkrazy/cfn-tools based off a github release tag - This requires a few Github secrets of `DOCKER_TOKEN` and `DOCKER_USERNAME` to be set in repo for Dockerhub user.

Autotagger - will auto tag on merge to the `main` branch, this will also kick off the above Docker_build_push to publish image to Dockerhub. This requires a Github secret of `GH_TOKEN` to be set in the repo

### Publishing to Docker Registries

This repo publishes both to Dockerhub publically, and uses my internal Jenkins/Anchore and Harbor registry for internal needs.

Dockerhub:

Upon succesful merge to the `main` branch a Github action called `autotagger` with create a tag based off the value in [package.json](package.json) - this needs to be updated in every PR to create new version.

Once that happens the tag creation will trigger the `docker_build_push` Github action to build and publish the image to Dockerhub

Jenkins:

Upon succesful merge to the `main` branch it will kick off a Jenkin job that builds the image, scans it with Anchore, and uploads it to my internal Harbor registry.