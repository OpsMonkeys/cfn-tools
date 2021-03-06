# CFN Build Container

## Summary

This repo contains the dockerfile for my Terraform Build Container. This is a lightweight container based off alpine that contains all the tools needed to provision work with Terraform:
Includes:
TFENV for managing Terraform versions (https://github.com/tfutils/tfenv)
Installs both Terraform 0.12 and Terraform 0.13
Terraform-docs for generating documentation (https://github.com/terraform-docs/terraform-docs)
TF Lint for linting of the code (https://github.com/terraform-linters/tflint)
Terragrunt (https://github.com/gruntwork-io/terragrunt)
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