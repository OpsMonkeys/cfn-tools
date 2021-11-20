#!/bin/bash

echo "Checking Version"
if ["${GIT_TAG}" == "${PACKAGE_VERSION}"];
then
    echo "Version is equal to current tag, please update"
else
    echo "Version not equal to current tag"
fi
