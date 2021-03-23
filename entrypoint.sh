#!/bin/sh
# set -eo pipefail
/bin/bash --login
cd cfn
exec $@
