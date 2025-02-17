#!/bin/bash

# action_env through bazel does not work https://github.com/bazelbuild/bazel/issues/8578
# providing env variables also does not work
# patching each update is not feasible on each update, neither automatable

echo STABLE_GIT_COMMIT "8c4ea850baec0a8579e80d44af44943f50a18d3e"
echo DATE "2025-02-13 12:53:26+00:00"
echo DATE_UNIX "1739447606"
echo DOCKER_TAG "v5.3.0"
echo STABLE_GIT_TAG "v5.3.0"
