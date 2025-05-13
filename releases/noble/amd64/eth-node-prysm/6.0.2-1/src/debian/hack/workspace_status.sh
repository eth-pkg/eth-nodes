#!/bin/bash

# action_env through bazel does not work https://github.com/bazelbuild/bazel/issues/8578
# providing env variables also does not work
# patching each update is not feasible on each update, neither automatable

echo STABLE_GIT_COMMIT "2ec1ef53dcb114da22698e8ccd9bc1e3aa8e3870"
echo DATE "2025-05-13 08:06:19+00:00"
echo DATE_UNIX "1747116379"
echo DOCKER_TAG "v6.0.2"
echo STABLE_GIT_TAG "v6.0.2"
