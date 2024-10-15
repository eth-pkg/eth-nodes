#!/bin/bash

# action_env through bazel does not work https://github.com/bazelbuild/bazel/issues/8578
# providing env variables also does not work
# patching each update is not feasible on each update, neither automatable

echo STABLE_GIT_COMMIT "3fa6d3bd9d15962afda9ac8016bc27fba1d77d1f"
echo DATE "2024-10-16 06:57:55+00:00"
echo DATE_UNIX "1729036675"
echo DOCKER_TAG "v5.1.1"
echo STABLE_GIT_TAG "v5.1.1"
