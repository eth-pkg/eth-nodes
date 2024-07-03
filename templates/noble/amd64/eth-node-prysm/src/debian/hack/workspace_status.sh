#!/bin/bash

# action_env through bazel does not work https://github.com/bazelbuild/bazel/issues/8578
# providing env variables also does not work
# patching each update is not feasible on each update, neither automatable

echo STABLE_GIT_COMMIT "<GIT_COMMIT_LONG>"
echo DATE "<BUILD_DATE_UTC>"
echo DATE_UNIX "<BUILD_DATE_UNIX_TIMESTAMP>"
echo DOCKER_TAG "v<CLIENT_VERSION>"
echo STABLE_GIT_TAG "v<CLIENT_VERSION>"
