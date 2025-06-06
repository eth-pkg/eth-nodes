#!/bin/bash

# action_env through bazel does not work https://github.com/bazelbuild/bazel/issues/8578
# providing env variables also does not work
# patching each update is not feasible on each update, neither automatable

echo STABLE_GIT_COMMIT "91b44360fcd74bad41f38b79bb3b05094408a2d0"
echo DATE "2025-06-06 12:53:26+00:00"
echo DATE_UNIX "1749207206"
echo DOCKER_TAG "v6.0.4"
echo STABLE_GIT_TAG "v6.0.4"
